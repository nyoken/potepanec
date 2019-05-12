require 'rails_helper'

RSpec.describe Potepan::HomeController, type: :controller do
  describe "#index" do
    let!(:new_products) { create_list(:product, 9) }

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
    it "have correct @related_products" do
      # 9つ以上表示されていないか（limit(NEW_PRODUCTS_LIMITが適用されているか）
      expect(assigns(:new_products)).to match_array new_products[1..8]
    end
  end
end
