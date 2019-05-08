require 'rails_helper'

RSpec.feature "Products", type: :feature do
  let!(:taxon) { create(:taxon) }
  let!(:product) { create(:product, taxons: [taxon]) }
  let!(:related_product) { create(:product, taxons: [taxon]) }
  let!(:not_related_product) { create(:product) }

  scenario "User accesses show page" do
    visit potepan_product_path(product.id)
    within ".media-body" do
      expect(page).to have_link "一覧ページへ戻る", href: potepan_category_path(product.taxons.ids.first)
      expect(page).to have_content product.name
      expect(page).to have_content product.display_price
      expect(page).to have_content product.description
    end

    within ".productsContent" do
      expect(page).to have_link related_product.name, href: potepan_product_path(related_product.id)
      expect(page).to have_content related_product.display_price
      expect(page).not_to have_link not_related_product.name, href: potepan_product_path(not_related_product.id)
    end
  end
end
