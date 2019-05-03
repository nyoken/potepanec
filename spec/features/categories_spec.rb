require 'rails_helper'

RSpec.feature "Categories", type: :feature do
  let!(:taxonomy) { create(:taxonomy) }
  let!(:taxon) { create(:taxon, taxonomy: taxonomy,  parent: taxonomy.root) }
  let!(:product1) { create(:product, taxons: [taxon]) }
  let!(:product2) { create(:product) }

  before { visit potepan_category_path(taxon.id) }

  # カテゴリーのshowページにアクセスできることを確認
  scenario "User accesses a show page" do
    within '.side-nav' do
      expect(page).to have_content taxonomy.name
      expect(page).to have_content taxon.name
      expect(product1.taxons.size).to eq taxon.all_products.count
    end

    within '.productCaption' do
      expect(page).to have_link(product1.name, href: potepan_product_path(product1.id))
      expect(page).to have_content product1.display_price
      expect(page).not_to have_link(product2.name, href: potepan_product_path(product2.id))
    end
  end

  # カテゴリーのshowページから、商品のshowページにアクセスできることを確認
  scenario "User accesses a product show page from a categories page" do
    click_link product1.name

    expect(page).to have_current_path potepan_product_path(product1.id)
  end

  # カテゴリーのshowページから、homeページにアクセスできることを確認
  scenario "User accesses a home page from a categories page" do
    click_link "Home", href: potepan_index_path

    expect(page).to have_current_path potepan_index_path
  end
end
