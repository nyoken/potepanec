#require 'rails_helper'

#RSpec.describe Potepan::CategoriesController, type: :controller do
#  describe "#show" do
#    let(:taxon) { create(:taxon) }
#    let!(:taxonomies) { create_list(:taxonomy, 2) }
#    let!(:products) { create_list(:product, 5) }

#    before { get :show, params: { id: taxon.id } }

    # 正常にレスポンスを返すか
#    it "responds successfully" do
#      expect(response).to be_successful
#    end

    # show.html.erbが描画されているか
#    it "render show view" do
#      expect(response).to render_template :show
#    end

    # 正しくtaxonが渡されているか
#    it "have correct taxon" do
#      expect(assigns(:taxon)).to eq(taxon)
#    end

    # 正しくtaxonomiesが渡されているか
#    it "have correct taxonomies" do
#      expect(assigns(taxonomies)).to match_array(Taxonomy.all)
#    end

    # 正しくproductsが渡されているか
#    it "have correct products" do
#      expect(assigns(products)).to match_array(Product.all)
#    end
#  end
#end
