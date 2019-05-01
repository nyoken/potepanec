require 'rails_helper'

RSpec.describe Potepan::CategoriesController, type: :controller do
  describe "#show" do
    let(:taxonomy) { create(:taxonomy) }
    let(:taxon) { create(:taxon, taxonomy: taxonomy) }

    before { get :show, params: { id: taxon.id } }

    # 正常にレスポンスを返すか
    it "responds successfully" do
      expect(response).to be_successful
    end

    # show.html.erbが描画されているか
    it "render show view" do
      expect(response).to render_template :show
    end

    # 正しく@taxonが渡されているか
    it "have correct @taxon" do
      expect(assigns(:taxon)).to eq(taxon)
    end

    # 正しく@taxonomiesが渡されているか
    it "have correct @taxonomies" do
      expect(assigns(:taxonomies)).to match_array(taxonomy)
    end
  end
end
