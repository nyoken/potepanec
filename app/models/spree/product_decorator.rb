Spree::Product.class_eval do
  # in_taxons(product.taxons)→productが持つtaxonと一致するproducts配列を返す
  # where.not(id: product.id).distinct→product自身を関連商品として表示しない
  scope :related_products, -> (product) do
    in_taxons(product.taxons).includes(master: [:default_price, :images]).where.not(id: product.id).distinct
  end

  # order(available_on: :desc)→available_onの値が降順になるように並び替える
  scope :new_products, -> { includes(master: [:default_price, :images]).order(available_on: :desc) }

  # 引数（URLクエリ）がある場合に、Variantモデル配下のOptionValueモデルを取得して、OptionValueのnameがURLクエリと一致する商品を取得
  scope :filter_by_option_values, -> (option_values) do
    if option_values.present?
      joins(variants: :option_values)
      .where(spree_option_values: { name: option_values })
    end
  end
end
