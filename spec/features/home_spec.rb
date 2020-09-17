require 'rails_helper'

RSpec.feature "Home", type: :feature do
  let!(:products) { create_list(:product, 8) }
  let!(:categories_taxon) { create(:taxon, name: :Categories, taxonomy_id: 1) }
  let!(:taxons) { create_list(:taxon, 3, taxonomy_id: 1) }

  scenario "User accesses show page" do
    visit potepan_root_path
    within ".featuredProducts" do
      expect(page).to have_link products.first.name, href: potepan_product_path(products.first.id)
      expect(page).to have_content products.first.display_price
    end
  end

  scenario "User accesses category page" do
    taxons.unshift(categories_taxon)
    visit potepan_root_path
    within ".featuredCollection" do
      expect(page).to have_link taxons[1].name, href: potepan_category_path(taxons[1].id)
      expect(page).to have_no_content "Categories"
    end
  end
end
