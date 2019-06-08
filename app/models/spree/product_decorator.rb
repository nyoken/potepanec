Spree::Product.class_eval do
  # in_taxons(product.taxons)→productが持つtaxonと一致するproducts配列を返す
  # where.not(id: product.id).distinct→product自身を関連商品として表示しない
  scope :related_products, -> (product) do
    in_taxons(product.taxons).includes(master: [:default_price, :images]).where.not(id: product.id).distinct
  end

  # カテゴリーで絞り込む
  scope :select_by_category, -> (taxon) do
    includes(master: [:default_price, :images]).in_taxon(taxon)
  end

  # 並び替え用スコープ
  scope :from_high_price_to_low_price, -> { includes(master: [:default_price, :images]).reorder("spree_prices.amount desc") }
  scope :from_low_price_to_high_price, -> { includes(master: [:default_price, :images]).reorder("spree_prices.amount") }
  scope :from_newest_to_oldest, -> { includes(master: [:default_price, :images]).reorder(available_on: :desc) }
  scope :from_oldest_to_newest, -> { includes(master: [:default_price, :images]).reorder(available_on: :asc) }

  # 引数（URLクエリ）がある場合に、Variantモデル配下のOptionValueモデルを取得して、OptionValueのnameがURLクエリと一致する商品を取得
  scope :filter_by_option_values, -> (option_values) do
    joins(variants: :option_values).where(spree_option_values: { name: option_values })
  end

  # 並び替え用メソッド
  scope :sort_in_order, -> (sort) do
    case sort
    when "NEW_PRODUCTS"
      from_newest_to_oldest
    when "OLD_PRODUCTS"
      from_oldest_to_newest
    when "LOW_PRICE"
      from_low_price_to_high_price
    when "HIGH_PRICE"
      from_high_price_to_low_price
    end
  end
end
