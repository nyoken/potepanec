require 'rails_helper'

RSpec.describe Potepan::HomeController, type: :controller do
  describe "#index" do
    let!(:new_products) { create_list(:product, 10, available_on: 2.day.ago) }
    let(:latest_product) { create(:product, available_on: 1.day.ago) }

    before { get :index }

    # 正常にレスポンスを返すか
    it "responds successfully" do
      expect(response).to be_successful
    end

    # index.html.erbが描画されているか
    it "render index view" do
      expect(response).to render_template :index
    end

    # 正しく@new_productsが渡されているか
    it "have correct @new_products" do
      # 9つ以上表示されていないか（limit(NEW_PRODUCTS_LIMITが適用されているか）
      expect(assigns(:new_products)).to match_array new_products[0..7]

      # 最新のproductが1番上に並び替えられているか（order(available_on: :desc)が適用されているか）
      latest_product
      expect(assigns(:new_products).reload.first).to eq latest_product
    end
  end
end
