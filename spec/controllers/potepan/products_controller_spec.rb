require 'rails_helper'

RSpec.describe Potepan::ProductsController, type: :controller do
  describe '#show' do
    let!(:taxon) { create(:taxon) }
    let!(:product) { create(:product, taxons: [taxon]) }
    let!(:related_products) { create_list(:product, 5, taxons: [taxon]) }

    before { get :show, params: { id: product.id } }

    # 正常にレスポンスを返すか
    it "responds successfully" do
      expect(response).to be_successful
    end

    # show.html.erbが描画されているか
    it "render show view" do
      expect(response).to render_template :show
    end

    # 正しく@productが渡されているか
    it "have correct @product" do
      expect(assigns(:product)).to eq product
    end

    # 正しく@productが渡されているか
    it "have correct @related_products" do
      expect(assigns(:related_products)).to include related_products[0]
    end
  end
end
