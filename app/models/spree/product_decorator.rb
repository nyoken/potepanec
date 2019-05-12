Spree::Product.class_eval do
  # in_taxons(product.taxons)→productが持つtaxonと一致するproducts配列を返す
  # where.not(id: product.id).distinct→product自身を関連商品として表示しない
  scope :related_products, -> (product) do
    in_taxons(product.taxons).includes(master: [:default_price, :images]).where.not(id: product.id).distinct
  end

  # order(available_on: :desc)→available_onの値が降順になるように並び替える
  scope :new_products, -> { includes(master: [:default_price, :images]).order(available_on: :desc) }
end
