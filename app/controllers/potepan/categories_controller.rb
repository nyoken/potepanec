class Potepan::CategoriesController < ApplicationController
  def show
    @taxon = Spree::Taxon.find(params[:id])

    # includes(:root)→「root:taxonomy = 1:n」なので、includesを使って「N+1問題」を解決。
    # SELECT `taxonomies`.* FROM `taxonomies` WHERE `taxonomies`.`root_id` IN (1, 2, 3, ...)
    @taxonomies = Spree::Taxonomy.includes(:root)

    # includes(master: [:default_price, :images])→product.master取得時、
    # (product.)master.default_price, (product.)master.images取得時の「N+1問題」を解決。
    # (product:master:[:default_price, :images] =n:1:n）
    @products = @taxon.all_products.includes(master: [:default_price, :images])
  end
end
