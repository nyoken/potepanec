class Potepan::ProductsController < ApplicationController
  RELATED_PRODUCTS_LIMIT = 4
  before_action :set_brands, only: [:search]

  def show
    @product = Spree::Product.find(params[:id])

    # related_products scopeは、app/models/spree/product_decoratorにて定義
    @related_products = Spree::Product.related_products(@product).limit(RELATED_PRODUCTS_LIMIT)
  end

  def search
    @search_word = params[:search]
    @products = Spree::Product.search(@search_word)
  end
end
