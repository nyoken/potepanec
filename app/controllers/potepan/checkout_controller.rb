class Potepan::CheckoutController < ApplicationController
  include Spree::Core::ControllerHelpers::StrongParameters
  include Spree::Core::ControllerHelpers::PaymentParameters
  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::Store

  before_action :load_order
  before_action :set_state_if_present
  before_action :setup_for_current_state, only: [:edit, :update]
  before_action :authenticate_user

  # Updates the order and advances to the next state (when possible.)
  def update
    if update_order
      unless transition_forward
        redirect_on_failure
        return
      end

      if @order.completed?
        finalize_order
      else
        @order.next if @order.state == "delivery"
        send_to_next_state
      end

    else
      render :edit
    end
  end

  private

  def update_order
    Spree::OrderUpdateAttributes.new(@order, update_params, request_env: request.headers.env).apply
  end

  def redirect_on_failure
    flash[:error] = @order.errors.full_messages.join("\n")
    redirect_to(potepan_checkout_state_path(@order.state))
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
    Spree::OrderMailer.confirm_email(@order).deliver_now
    set_successful_flash_notice
    redirect_to completion_route
  end

  def set_successful_flash_notice
    flash.notice = t('spree.order_processed_successfully')
  end

  def send_to_next_state
    redirect_to potepan_checkout_state_path(@order.state)
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
      Spree::Deprecation.
      warn("Passing order[:existing_card] is deprecated. Send order[:wallet_payment_source_id] instead.", caller)
      move_existing_card_into_payments_attributes(massaged_params) # deprecated
    end
    move_wallet_payment_source_id_into_payments_attributes(massaged_params)
    set_payment_parameters_amount(massaged_params, @order)

    massaged_params
  end

  # Should be overriden if you have areas of your checkout that don't match
  # up to a step within checkout_steps, such as a registration step
  def skip_state_validation?
    false
  end

  # @orderがない場合、カートページに遷移
  def load_order
    @order = current_order
    redirect_to(potepan_cart_path) && return unless @order
  end

  # params[:state]がある場合、次のステップへ進む
  def set_state_if_present
    if params[:state]
      redirect_to potepan_checkout_state_path(@order.state) if @order.can_go_to_state?(params[:state]) && !skip_state_validation?
      @order.state = params[:state]
    end
  end

  # Provides a route to redirect after order completion
  def completion_route
    potepan_order_path(@order)
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
    @order.build_ship_address(default) unless @order.ship_address
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

      # TODO: How can we deprecate this instance variable?  We could try
      # wrapping it in a delegating object that produces deprecation warnings.
      @payment_sources = try_spree_current_user.wallet.wallet_payment_sources.
        map(&:payment_source).
        select { |ps| ps.is_a?(Spree::CreditCard) }
    end
  end
end
