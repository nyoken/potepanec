class Potepan::CategoriesController < ApplicationController
  # Viewでcount_number_of_productsメソッドを使えるようにする
  helper_method :count_number_of_index_products
  helper_method :count_number_of_show_products

  def index
    @taxonomies = Spree::Taxonomy.includes(:root)

    @option_types = Spree::OptionType.includes(:option_values)

    @products =
      if params[:color]
        Spree::Product.includes(master: [:default_price]).
          filter_by_option_values(filter_params[:color]).
          distinct
      elsif params[:size]
        Spree::Product.includes(master: [:default_price]).
          filter_by_option_values(filter_params[:size]).
          distinct
      elsif params[:sort]
        Spree::Product.includes(master: [:default_price]).
          sort_in_order(filter_params[:sort])
      else
        Spree::Product.includes(master: [:default_price]).
          from_newest_to_oldest
      end
  end

  def show
    # includesで「N+1問題」を解決
    # SELECT `taxonomies`.* FROM `taxonomies` WHERE `taxonomies`.`root_id` IN (1, 2, 3, ...)
    @taxonomies = Spree::Taxonomy.includes(:root)

    @taxon = Spree::Taxon.find(params[:id])

    @option_types = Spree::OptionType.includes(:option_values)

    @products =
      if params[:color] && params[:sort]
        Spree::Product.select_by_category(@taxon).
          filter_by_option_values(filter_params[:color]).
          sort_in_order(filter_params[:sort])
      elsif params[:size] && params[:sort]
        Spree::Product.select_by_category(@taxon).
          filter_by_option_values(filter_params[:size]).
          sort_in_order(filter_params[:sort])
      elsif params[:color] && params[:size]
        colors_ids = Spree::Product.
          select_by_category(@taxon).
          filter_by_option_values(filter_params[:color]).ids
        sizes_ids = Spree::Product.
          select_by_category(@taxon).
          filter_by_option_values(filter_params[:size]).ids
        Spree::Product.where(id: colors_ids & sizes_ids)
      elsif params[:color]
        Spree::Product.select_by_category(@taxon).
          filter_by_option_values(filter_params[:color])
      elsif params[:size]
        Spree::Product.select_by_category(@taxon).
          filter_by_option_values(filter_params[:size])
      elsif params[:sort]
        Spree::Product.select_by_category(@taxon).
          sort_in_order(filter_params[:sort])
      else
        Spree::Product.select_by_category(@taxon).
          from_newest_to_oldest
      end
  end

  private

  # URLクエリをストロングパラメーターで取得
  def filter_params
    { color: params[:color], size: params[:size], sort: params[:sort] }
  end

  # Color, Sizeなどのoption_valueに応じた商品数を取得するメソッド
  def count_number_of_index_products(option_value)
    Spree::Product.includes(variants: :option_values).
      where(spree_option_values: { name: option_value }).
      count
  end

  def count_number_of_show_products(option_value)
    Spree::Product.includes(variants: :option_values).
      in_taxon(@taxon).
      where(spree_option_values: { name: option_value }).
      count
  end
end
