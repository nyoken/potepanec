class Potepan::CheckoutController < ApplicationController
  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::Store
  include Spree::Core::ControllerHelpers::StrongParameters
  include Spree::Core::ControllerHelpers::PaymentParameters

  before_action :load_order
  before_action :set_state_if_present

  before_action :ensure_order_not_completed
  before_action :ensure_checkout_allowed
  before_action :ensure_sufficient_stock_lines
  before_action :ensure_valid_state

  before_action :associate_user
  before_action :check_authorization

  before_action :setup_for_current_state, only: [:edit, :update]

  # Updates the order and advances to the next state (when possible.)
  def update
    if update_order

      assign_temp_address

      unless transition_forward
        redirect_on_failure
        return
      end

      if @order.completed?
        finalize_order
      else
        send_to_next_state
      end

    else
      render :edit
    end
  end

  private

  def update_order
    OrderUpdateAttributes.new(@order, update_params, request_env: request.headers.env).apply
  end

  def assign_temp_address
    @order.temporary_address = !params[:save_user_address]
  end

  def redirect_on_failure
    flash[:error] = @order.errors.full_messages.join("\n")
    redirect_to(checkout_state_path(@order.state))
  end

  def transition_forward
    if @order.can_complete?
      @order.complete
    else
      @order.next
    end
  end

  def finalize_order
    @current_order = nil
    set_successful_flash_notice
    redirect_to completion_route
  end

  def set_successful_flash_notice
    flash.notice = t('spree.order_processed_successfully')
    flash['order_completed'] = true
  end

  def send_to_next_state
    redirect_to checkout_state_path(@order.state)
  end

  def update_params
    if update_params = massaged_params[:order]
      update_params.permit(permitted_checkout_attributes)
    else
      # We currently allow update requests without any parameters in them.
      {}
    end
  end

  def massaged_params
    massaged_params = params.deep_dup

    move_payment_source_into_payments_attributes(massaged_params)
    if massaged_params[:order] && massaged_params[:order][:existing_card].present?
      Spree::Deprecation.warn("Passing order[:existing_card] is deprecated. Send order[:wallet_payment_source_id] instead.", caller)
      move_existing_card_into_payments_attributes(massaged_params) # deprecated
    end
    move_wallet_payment_source_id_into_payments_attributes(massaged_params)
    set_payment_parameters_amount(massaged_params, @order)

    massaged_params
  end

  def ensure_valid_state
    unless skip_state_validation?
      if (params[:state] && !@order.has_checkout_step?(params[:state])) ||
         (!params[:state] && !@order.has_checkout_step?(@order.state))
        @order.state = 'cart'
        redirect_to checkout_state_path(@order.checkout_steps.first)
      end
    end

    # Fix for https://github.com/spree/spree/issues/4117
    # If confirmation of payment fails, redirect back to payment screen
    if params[:state] == "confirm" && @order.payment_required? && @order.payments.valid.empty?
      flash.keep
      redirect_to checkout_state_path("payment")
    end
  end

  # Should be overriden if you have areas of your checkout that don't match
  # up to a step within checkout_steps, such as a registration step
  def skip_state_validation?
    false
  end

  # params[:state]がある場合、次のステップへ進む
  def load_order
    @order = current_order
    redirect_to(spree.cart_path) && return unless @order
  end

  # params[:state]がある場合、次のステップへ進む
  def set_state_if_present
    if params[:state]
      redirect_to checkout_state_path(@order.state) if @order.can_go_to_state?(params[:state]) && !skip_state_validation?
      @order.state = params[:state]
    end
  end

  def ensure_checkout_allowed
    unless @order.checkout_allowed?
      redirect_to spree.cart_path
    end
  end

  def ensure_order_not_completed
    redirect_to spree.cart_path if @order.completed?
  end

  def ensure_sufficient_stock_lines
    if @order.insufficient_stock_lines.present?
      out_of_stock_items = @order.insufficient_stock_lines.collect(&:name).to_sentence
      flash[:error] = t('spree.inventory_error_flash_for_insufficient_quantity', names: out_of_stock_items)
      redirect_to spree.cart_path
    end
  end

  # Provides a route to redirect after order completion
  def completion_route
    spree.order_path(@order)
  end

  def setup_for_current_state
    method_name = :"before_#{@order.state}"
    send(method_name) if respond_to?(method_name, true)
  end

  def before_address
    @order.assign_default_user_addresses
    # If the user has a default address, the previous method call takes care
    # of setting that; but if he doesn't, we need to build an empty one here
    default = { country_id: Spree::Country.default.id }
    @order.build_bill_address(default) unless @order.bill_address
    @order.build_ship_address(default) if @order.checkout_steps.include?('delivery') && !@order.ship_address
  end

  def before_delivery
    return if params[:order].present?

    packages = @order.shipments.map(&:to_package)
    @differentiator = Spree::Stock::Differentiator.new(@order, packages)
  end

  def before_payment
    if @order.checkout_steps.include? "delivery"
      packages = @order.shipments.map(&:to_package)
      @differentiator = Spree::Stock::Differentiator.new(@order, packages)
      @differentiator.missing.each do |variant, quantity|
        @order.contents.remove(variant, quantity)
      end
    end

    if try_spree_current_user && try_spree_current_user.respond_to?(:wallet)
      @wallet_payment_sources = try_spree_current_user.wallet.wallet_payment_sources
      @default_wallet_payment_source = @wallet_payment_sources.detect(&:default) ||
                                       @wallet_payment_sources.first

      @payment_sources = Spree::DeprecatedInstanceVariableProxy.new(
        self,
        :deprecated_payment_sources,
        :@payment_sources,
        Spree::Deprecation,
        "Please, do not use @payment_sources anymore, use @wallet_payment_sources instead."
      )
    end
  end

  def check_authorization
    authorize!(:edit, current_order, cookies.signed[:guest_token])
  end

  # This method returns payment sources of the current user. It is no more
  # used into our frontend. We used to assign the content of this method
  # into an ivar (@payment_sources) into the checkout payment step. This
  # method is here only to be able to deprecate this ivar and will be removed.
  #
  # DO NOT USE THIS METHOD!
  #
  # @return [Array<Spree::PaymentSource>] Payment sources connected to
  #   current user wallet.
  # @deprecated This method has been added to deprecate @payment_sources
  #   ivar and will be removed. Use @wallet_payment_sources instead.
  def deprecated_payment_sources
    try_spree_current_user.wallet.wallet_payment_sources
      .map(&:payment_source)
      .select { |ps| ps.is_a?(Spree::CreditCard) }
  end
end
