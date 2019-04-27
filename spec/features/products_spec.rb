require 'rails_helper'

RSpec.feature "Products", type: :feature do
  let(:product) { create(:product, name: "TestProduct", price: 100) }

  scenario "User accesses show page" do
    visit potepan_product_path(product.id)
    within '.media-body' do
      expect(page).to have_content product.name
      expect(page).to have_content product.display_price
      expect(page).to have_content product.description
    end
  end
end
