class Potepan::HomeController < ApplicationController
  POPULAR_CATEGORIES_LIMIT = 3
  NEW_PRODUCTS_LIMIT = 8
  before_action :set_taxonomies_and_option_types
  before_action :set_brands

  def index
    @category_taxons = Spree::Taxon.where(taxonomy_id: 1).
      where.not(name: :Categories).limit(POPULAR_CATEGORIES_LIMIT)
    # new_products scopeは、app/models/spree/product_decoratorにて定義
    @new_products = Spree::Product.includes(master: [:default_price, :images]).
      from_newest_to_oldest.limit(NEW_PRODUCTS_LIMIT)
  end
end
