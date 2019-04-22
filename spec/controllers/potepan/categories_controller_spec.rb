require 'rails_helper'

RSpec.describe Potepan::CategoriesController, type: :controller do

  describe "#show" do
    subject { get :show, params: { id: taxonomy.id } }

    let(:taxonomy) { create(:taxonomy) }

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

    # 正しくtaxnomyが渡されているか
    it "have correct taxonomy" do
      subject
      expect(assigns(:taxonomy)).to eq(taxonomy)
    end
  end
end
