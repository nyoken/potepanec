require 'rails_helper'

RSpec.feature "Home", type: :feature do
  let!(:products) { create_list(:product, 8) }

  scenario "User accesses show page" do
    visit potepan_root_path
    within ".featuredProducts" do
      expect(page).to have_link products.first.name, href: potepan_product_path(products.first.id)
      expect(page).to have_content products.first.display_price
    end
  end
end
