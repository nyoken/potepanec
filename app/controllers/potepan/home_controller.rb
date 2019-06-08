class Potepan::HomeController < ApplicationController
  NEW_PRODUCTS_LIMIT = 8

  def index
    # new_products scopeは、app/models/spree/product_decoratorにて定義
    @new_products = Spree::Product.from_newest_to_oldest.limit(NEW_PRODUCTS_LIMIT)
  end
end