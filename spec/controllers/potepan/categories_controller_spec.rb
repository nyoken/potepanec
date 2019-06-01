require 'rails_helper'

RSpec.describe Potepan::CategoriesController, type: :controller do
  describe "#show" do
    let!(:taxonomies) { create_list(:taxonomy, 3) }
    let!(:taxon) { create(:taxon, taxonomy: taxonomies[0]) }
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
        create(:option_value, name: "Small", option_type: option_types[1]),
        create(:option_value, name: "Medium", option_type: option_types[1])
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
        create(:product, taxons: [taxon], variants: [variants[1], variants[3]]),
        create(:product, taxons: [taxon], variants: [variants[2]]),
        create(:product, taxons: [taxon], variants: [variants[3]])
      ]
    end
    let!(:product_not_associated_with_taxon) { create(:product) }

    before { get :show, params: { id: taxon.id } }

    # 正常にレスポンスを返すか
    it "responds successfully" do
      expect(response).to be_successful
    end

    # show.html.erbが描画されているか
    it "renders show view" do
      expect(response).to render_template :show
    end

    # 正しく@taxonが渡されているか
    it "has correct @taxon" do
      expect(assigns(:taxon)).to eq(taxon)
    end

    # 正しく@taxonomiesが渡されているか
    it "has correct @taxonomies" do
      expect(assigns(:taxonomies)).to match_array(taxonomies)
    end

    # 正しく@colorsが渡されているか
    it "has correct @option_types" do
      expect(assigns(:option_types)).to match_array(option_types)
    end

    # params[:color]が存在する時、@productsにcolorフィルターがかかっているか
    it "has @products filtered by color when params[:color] exists" do
      get :show, params: { id: taxon.id, color: "Red" }
      expect(assigns(:products)).to include(products[0])
      expect(assigns(:products)).not_to include(products[1])
      expect(assigns(:products)).not_to include(product_not_associated_with_taxon)
    end

    # params[:size]が存在する時、@productsにsizeフィルターがかかっているか
    it "has @products filtered by size when params[:size] exists" do
      get :show, params: { id: taxon.id, size: "Small" }
      expect(assigns(:products)).to include(products[2])
      expect(assigns(:products)).not_to include(products[3])
      expect(assigns(:products)).not_to include(product_not_associated_with_taxon)
    end

    # params[:color]、params[:size]の両方が存在する時、@productsにcolorとsizeフィルターがかかっているか
    it "has @products filtered by color & size when params[:color] & params[:size] exist" do
      get :show, params: { id: taxon.id, color: "Blue", size: "Medium" }
      expect(assigns(:products)).to include(products[1])
      expect(assigns(:products)).not_to include(products[3])
      expect(assigns(:products)).not_to include(product_not_associated_with_taxon)
    end

    # params[:color]、params[:size]がいずれも存在しない時、@productsにフィルターがかかっていないか
    it "has @products not filtered by color & size when params[:color] & params[:size] don't exist" do
      expect(assigns(:products)).to match_array(products)
      expect(assigns(:products)).not_to include(product_not_associated_with_taxon)
    end
  end
end
