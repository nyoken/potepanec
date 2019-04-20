require 'rails_helper'

RSpec.describe Potepan::ProductsController, type: :controller do
  describe '#show' do
    subject { get :show, params: { id: product.id } }

    let(:product) { create(:product) }

    # 正常にレスポンスを返すか
    it "responds successfully" do
      subject
      expect(response).to be_successful
    end

    # show.html.erbが描画されているか
    it "render show view" do
      subject
      expect(response).to render_template :show
    end

    # 正しくproductが渡されているか
    it "have correct product" do
      subject
      expect(assigns(:product)).to eq(product)
    end
  end
end
