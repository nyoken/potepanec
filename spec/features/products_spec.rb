require 'rails_helper'

RSpec.feature "Products", type: :feature do
  let!(:taxonomy) { create(:taxonomy) }
  let!(:taxon) { create(:taxon, taxonomy: taxonomy, parent: taxonomy.root) }
  let!(:product) { create(:product, name: "TestProduct", price: 100, taxons: [taxon]) }

  scenario "User accesses show page" do
    visit potepan_product_path(product.id)
    within '.media-body' do
      expect(page).to have_link "一覧ページへ戻る", href: potepan_category_path(product.taxons.ids.first)
      expect(page).to have_content product.name
      expect(page).to have_content product.display_price
      expect(page).to have_content product.description
    end
  end
end
