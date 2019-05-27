require 'rails_helper'

RSpec.describe Potepan::CategoriesController, type: :controller do
  describe "#show" do
    let!(:taxonomy) { create(:taxonomy) }
    let!(:taxon) { create(:taxon, taxonomy: taxonomy) }
    let!(:color) { create(:option_type, presentation: "Color") }
    let!(:size) { create(:option_type, presentation: "Size") }

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
      expect(assigns(:taxonomies)).to match_array(taxonomy)
    end

    # 正しく@colorsが渡されているか
    it "has correct @colors" do
      expect(assigns(:colors)).to eq(color.option_values)
    end
  end
end
