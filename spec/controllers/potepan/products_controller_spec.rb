require 'rails_helper'

RSpec.describe Potepan::ProductsController, type: :controller do
  describe '#show' do
    let(:product) { create(:product) }
    subject { get :show, params: { id: product.id } }

    # 正常にレスポンスを返すか
    it "responds successfully" do
      subject
      expect(response).to be_success
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
