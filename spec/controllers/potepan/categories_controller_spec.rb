require 'rails_helper'

RSpec.describe Potepan::CategoriesController, type: :controller do
  describe "#show" do
    let(:taxonomy) { create(:taxonomy) }
    let(:taxon) { create(:taxon, taxonomy: taxonomy) }
    let(:product1) { create(:product, taxons: [taxon]) }
    let(:product2) { create(:product) }

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

    # 正しく@productsが渡されているか
    it "have correct @products" do
      expect(assigns(:products)).to match_array(product1)
    end

    # 誤った@productsが渡されていないか
    it "doesn't have incorrect @products" do
      expect(assigns(:products)).to_not match_array(product2)
    end
  end
end
