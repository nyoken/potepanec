require 'rails_helper'

RSpec.describe Potepan::ProductsController, type: :controller do
  describe '#show' do
    let(:product) { create(:product) }

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
      expect(assigns(:product)).to eq(product)
    end
  end
end
