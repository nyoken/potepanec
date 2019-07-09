class Potepan::OrdersController < ApplicationController
  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::Store

  def show
    @order = Spree::Order.find_by(number: params[:id])
  end

  def edit
    # https://github.com/solidusio/solidus/blob/master/frontend/app/controllers/spree/orders_controller.rb
    @order = current_order || Spree::Order.incomplete.
      find_or_initialize_by(guest_token: cookies.signed[:guest_token])
  end

  def add_cart
    # 新しいアイテムをカートに追加
    # https://github.com/solidusio/solidus/blob/master/frontend/app/controllers/spree/orders_controller.rb
    @order = current_order(create_order_if_necessary: true)
    authorize! :update, @order, cookies.signed[:guest_token]

    variant  = Spree::Variant.find(params[:variant_id])
    quantity = params[:quantity].to_i

    # あり得ない量が注文されてエラーが起きる防ぐために 発注の最大値を設定する
    if !quantity.between?(1, 2_147_483_647)
      @order.errors.add(:base, t('spree.please_enter_reasonable_quantity'))
    end

    # カートのアップデート時にエラーが起こった場合に、500エラーを吐かせ図にメッセージを返す
    begin
      @line_item = @order.contents.add(variant, quantity)
    rescue ActiveRecord::RecordInvalid => e
      @order.errors.add(:base, e.record.errors.full_messages.join(", "))
    end

    if @order.errors.any?
      flash[:error] = @order.errors.full_messages.join(", ")
      redirect_back_or_default potepan_root_path
      return
    else
      redirect_to potepan_cart_path
    end
  end

  def update
    @order = Spree::Order.find_by(number: params[:number])
    if @order.contents.update_cart(order_params)
      # formの送信先のnameがcheckoutの場合、次ステップに進む
      @order.next if params.key?(:checkout) && @order.cart?
      if params.key?(:checkout)
        redirect_to potepan_checkout_state_path(@order.checkout_steps.first)
      else
        redirect_to potepan_cart_path
      end
    end
  end

  private

  def order_params
    params.require(:order).permit(line_items_attributes: [:id, :quantity])
  end
end
