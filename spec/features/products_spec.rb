require 'rails_helper'

RSpec.feature "Products", type: :feature do
  let!(:taxon) { create(:taxon) }
  let!(:product) { create(:product, taxons: [taxon]) }
  let!(:related_product) { create(:product, taxons: [taxon]) }
  let!(:not_related_product) { create(:product) }
  let!(:ruby_product) { create(:product, name: "RUBY BAG") }
  let!(:rails_product) { create(:product, name: "RAILS BAG") }

  scenario "User accesses show page" do
    visit potepan_product_path(product.id)
    within ".media-body" do
      expect(page).to have_link "一覧ページへ戻る", href: potepan_category_path(product.taxons.ids.first)
      expect(page).to have_content product.name
      expect(page).to have_content product.display_price
      expect(page).to have_content product.description
    end

    within ".productsContent" do
      # @productと同じtaxonを持つ商品名とリンクが表示されている
      expect(page).to have_link related_product.name, href: potepan_product_path(related_product.id)
      # 関連商品の値段が表示されている
      expect(page).to have_content related_product.display_price
      # 関連商品に@productと同様の商品名が表示されていない
      expect(page).not_to have_content product.name
      # @productと異なるtaxonを持つ商品名とリンクが表示されていない
      expect(page).not_to have_link not_related_product.name, href: potepan_product_path(not_related_product.id)
    end
  end
  scenario "User accesses search page" do
    visit search_potepan_products_path(search: "RUBY")
    within ".page-title" do
      expect(page).to have_content("RUBY")
    end

    within ".productsContent" do
      expect(page).to have_link ruby_product.name, href: potepan_product_path(ruby_product.id)
      expect(page).to have_content ruby_product.display_price
      expect(page).not_to have_link rails_product.name, href: potepan_product_path(rails_product.id)
    end
  end
end
