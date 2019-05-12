class Potepan::ProductsController < ApplicationController
  RELATED_PRODUCTS_LIMIT = 4

  def show
    @product = Spree::Product.find(params[:id])

    # related_products scopeは、app/models/spree/product_decoratorにて定義
    @related_products = Spree::Product.related_products(@product).limit(RELATED_PRODUCTS_LIMIT)
  end
end
