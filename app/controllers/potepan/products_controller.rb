class Potepan::ProductsController < ApplicationController
  def show
    @product = Spree::Product.find(params[:id])
    @related_products = @product.taxons.first.all_products.includes(master: [:default_price, :images])
  end
end
