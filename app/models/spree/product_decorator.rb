Spree::Product.class_eval do
  scope :related_products, -> (product) do
    in_taxons(product.taxons).includes(master: [:default_price, :images]).where.not(id: product.id).distinct
  end

  scope :new_products, -> { includes(master: [:default_price, :images]).order(available_on: :desc) }
end
