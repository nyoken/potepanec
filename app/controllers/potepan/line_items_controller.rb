class Potepan::LineItemsController < ApplicationController
  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::Store

  def destroy
    item = Spree::LineItem.find(params[:id])
    item.order.contents.remove_line_item(item)
    redirect_to potepan_cart_path
  end
end
