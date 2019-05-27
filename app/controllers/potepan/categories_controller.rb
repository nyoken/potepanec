class Potepan::CategoriesController < ApplicationController

  # 各アクションの前に、set_colors, set_sizesメソッドを実行する
  before_action :set_colors, :set_sizes

  # Viewでcount_number_of_productsメソッドを使えるようにする
  helper_method :count_number_of_products

  def show
    @taxon = Spree::Taxon.find(params[:id])

    # includesで「N+1問題」を解決
    # SELECT `taxonomies`.* FROM `taxonomies` WHERE `taxonomies`.`root_id` IN (1, 2, 3, ...)
    @taxonomies = Spree::Taxonomy.includes(:root)

    # includesで「N+1問題」を解決
    # Productのmaster_variant（Variantモデル）と、その配下のDefaultPriceモデル, Imageモデルを取得
    # in_taxonメソッド→引数のTaxonを持つproductsの配列を返す
    @filtered_products = Spree::Product.includes(master: [:default_price, :images]).in_taxon(@taxon)
                            .filter_by_option_values(filter_params)
  end

  private

    # URLクエリをストロングパラメーターで取得
    def filter_params
      [ params[:color], params[:size] ]
    end

    # OptionTypeがColorであるOptionValueの配列を取得
    def set_colors
      @colors = Spree::OptionType.find_by(presentation: "Color").option_values
    end

    # OptionTypeがSizeであるOptionValueの配列を取得
    def set_sizes
      @sizes = Spree::OptionType.find_by(presentation: "Size").option_values
    end

    # Color, Sizeなどのoption_valueに応じた商品数を取得するメソッド
    def count_number_of_products(option_value)
      Spree::Product.includes(variants: :option_values)
        .in_taxon(@taxon)
        .where(spree_option_values: { name: option_value })
        .count
    end
end
