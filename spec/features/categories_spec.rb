require 'rails_helper'

RSpec.feature "Categories", type: :feature do
  let!(:taxonomy) { create(:taxonomy) }
  let!(:taxon) { create(:taxon, taxonomy: taxonomy, parent: taxonomy.root) }
  let!(:option_types) do
    [
      create(:option_type, presentation: "Color"),
      create(:option_type, presentation: "Size")
    ]
  end
  let!(:colors) do
    [
      create(:option_value, name: "Red", option_type: option_types[0]),
      create(:option_value, name: "Blue", option_type: option_types[0])
    ]
  end
  let!(:sizes) do
    [
      create(:option_value, name: "Small", presentation: "S", option_type: option_types[1]),
      create(:option_value, name: "Medium", presentation: "M", option_type: option_types[1])
    ]
  end
  let!(:variants) do
    [
      create(:variant, option_values: [colors[0]]),
      create(:variant, option_values: [colors[1]]),
      create(:variant, option_values: [sizes[0]]),
      create(:variant, option_values: [sizes[1]])
    ]
  end
  let!(:products) do
    [
      create(:product, taxons: [taxon], variants: [variants[0]]),
      create(:product, taxons: [taxon], variants: [variants[1]]),
      create(:product, taxons: [taxon], variants: [variants[2]]),
      create(:product, taxons: [taxon], variants: [variants[3]])
    ]
  end
  let!(:product_not_associated_with_taxon) { create(:product) }

  before { visit potepan_category_path(taxon.id) }

  # カテゴリーのshowページにアクセスできることを確認
  scenario "User accesses a show page" do
    # サイドバーの確認
    within '.sideBar' do
      # カテゴリーフィルター
      expect(page).to have_content taxonomy.name
      expect(page).to have_link taxon.name, href: potepan_category_path(taxon.id)
      expect(page).to have_content "(#{taxon.all_products.count})"

      # 色フィルター
      expect(page).to have_link colors[0].name, href: "#{potepan_category_path(taxon.id)}?color=#{colors[0].name}"

      # サイズフィルター
      expect(page).to have_link sizes[0].presentation, href: "#{potepan_category_path(taxon.id)}?size=#{sizes[0].name}"
    end

    # メインパネルの確認
    within ".productBox", match: :first do
      expect(page).to have_link products[0].name, href: potepan_product_path(products[0].id)
      expect(page).to have_content products[0].display_price
      expect(page).not_to have_link product_not_associated_with_taxon.name,
        href: potepan_product_path(product_not_associated_with_taxon.id)
    end
  end

  # 商品名から、商品showページにアクセスできることを確認
  scenario "User accesses a product show page from a product name in categories page" do
    click_link products[0].name

    expect(page).to have_current_path potepan_product_path(products[0].id)
  end

  # homeページにアクセスできることを確認
  scenario "User accesses a home page from a categories page" do
    click_link "Home", href: potepan_path

    expect(page).to have_current_path potepan_path
  end

  # 色フィルターをかけられることを確認
  scenario "User accesses categories page filtered by color" do
    click_link colors[0].name
    expect(page).to have_content products[0].name
    expect(page).not_to have_content products[1].name
  end
end
