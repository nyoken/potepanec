class Potepan::CategoriesController < ApplicationController
  # Viewでcount_number_of_productsメソッドを使えるようにする
  helper_method :count_number_of_products

  def show
    # includesで「N+1問題」を解決
    # SELECT `taxonomies`.* FROM `taxonomies` WHERE `taxonomies`.`root_id` IN (1, 2, 3, ...)
    @taxonomies = Spree::Taxonomy.includes(:root)

    @taxon = Spree::Taxon.find(params[:id])

    @option_types = Spree::OptionType.includes(:option_values)

    @products =
      if params[:color].present?
        Spree::Product.select_by_category(@taxon).filter_by_option_values(filter_params[:color])
      elsif params[:size].present?
        Spree::Product.select_by_category(@taxon).filter_by_option_values(filter_params[:size])
      elsif params[:color].present? && params[:size].present?
        colors = Spree::Product.select_by_category(@taxon).filter_by_option_values(filter_params[:color]).ids
        sizes = Spree::Product.select_by_category(@taxon).filter_by_option_values(filter_params[:size]).ids
        Spree::Product.where(id: colors & sizes)
      else
        Spree::Product.select_by_category(@taxon)
      end
  end

  private

    # URLクエリをストロングパラメーターで取得
    def filter_params
      { color: params[:color], size: params[:size] }
    end

    # Color, Sizeなどのoption_valueに応じた商品数を取得するメソッド
    def count_number_of_products(option_value)
      Spree::Product.includes(variants: :option_values)
        .in_taxon(@taxon)
        .where(spree_option_values: { name: option_value })
        .count
    end
end
