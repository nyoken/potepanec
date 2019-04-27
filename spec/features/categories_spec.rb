require 'rails_helper'

RSpec.feature "Categories", type: :feature do
  let!(:taxonomy) { create(:taxonomy) }
  let!(:taxon) { create(:taxon, taxonomy: taxonomy,  parent: taxonomy.root) }
  let!(:product) { create(:product, taxons: [taxon]) }

  # カテゴリーのshowページにアクセスできることを確認
  scenario "User accesses a show page" do
    visit potepan_category_path(taxon.id)
    within '.side-nav' do
      expect(page).to have_content taxonomy.name
      expect(page).to have_content taxon.name
    end

    within '.productCaption' do
      expect(page).to have_link(product.name, href: potepan_product_path(product.id))
      expect(page).to have_content product.display_price
    end
  end

  # カテゴリーのshowページから、商品のshowページにアクセスできることを確認
  scenario "User accesses a product show page from a categories page" do
    user = FactoryBot.create(:user)
    visit potepan_category_path(taxon.id)
    click_link product.name

    expect(page).to have_current_path potepan_product_path(product.id)
  end
end
