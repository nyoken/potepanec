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

    # 正しく@related_productsが渡されているか
    it "have correct @related_products" do
      # 4つ以上表示されていないか（limit(RELATED_PRODUCTS_LIMITが適用されているか）
      expect(assigns(:related_products)).to match_array related_products[0..3]
    end
  end

  describe '#search' do
    let!(:products) do
      [
        create(:product, name: "RUBY BAG", description: "This is a ruby bag"),
        create(:product, name: "ROR MUG", description: "This is a ruby on rails mug"),
        create(:product, name: "SHIRT", description: "This is a shirt"),
      ]
    end

    before { get :search, params: { search: "RUBY" } }

    # 正常にレスポンスを返すか
    it "responds successfully" do
      expect(response).to be_successful
    end

    # search.html.erbが描画されているか
    it "render search view" do
      expect(response).to render_template :search
    end

    # 名前と概要に"RUBY"が含まれている@productsを取得できているか
    it "has correct @products" do
      expect(assigns(:products)).to include products[0]
      expect(assigns(:products)).to include products[1]
      expect(assigns(:products)).not_to include products[2]
    end

    context "when params[:search] has metacharacter" do
      let(:metacharacter_product) { create(:product, name: 'COTTON100% BAG') }
      let(:no_metacharacter_product) { create(:product, name: 'BAG') }

      before { get :search, params: { search: "100%" } }

      it "has the product includes metacharacter" do
        expect(assigns(:products)).to include(metacharacter_product)
        expect(assigns(:products)).not_to include(no_metacharacter_product)
      end
    end
  end
end
