require 'rails_helper'

RSpec.describe Potepan::CategoriesController, type: :controller do
  describe "GET #show" do
    let!(:taxonomies) { create_list(:taxonomy, 3) }
    let!(:taxon) { create(:taxon, taxonomy: taxonomies[0]) }
    let!(:product_not_has_taxon) { create(:product) }
    let!(:option_types) do
      [
        create(:option_type, presentation: "Color"),
        create(:option_type, presentation: "Size"),
      ]
    end

    describe "no filters" do
      let!(:products) { create_list(:product, 3, taxons: [taxon]) }

      before { get :show, params: { id: taxon.id } }

      # 正常にレスポンスを返すか
      it "responds successfully" do
        expect(response).to be_successful
      end

      # show.html.erbが描画されているか
      it "renders show view" do
        expect(response).to render_template :show
      end

      # 正しく@taxonが渡されているか
      it "has correct @taxon" do
        expect(assigns(:taxon)).to eq(taxon)
      end

      # 正しく@taxonomiesが渡されているか
      it "has correct @taxonomies" do
        expect(assigns(:taxonomies)).to match_array(taxonomies)
      end

      # 正しく@colorsが渡されているか
      it "has correct @option_types" do
        expect(assigns(:option_types)).to match_array(option_types)
      end
    end

    describe "filters_by_color&size" do
      let!(:colors) do
        [
          create(:option_value, name: "Red", presentation: "Red", option_type: option_types[0]),
          create(:option_value, name: "BLue", presentation: "Blue", option_type: option_types[0]),
        ]
      end
      let!(:sizes) do
        [
          create(:option_value, name: "Small", presentation: "S", option_type: option_types[1]),
          create(:option_value, name: "Medium", presentation: "M", option_type: option_types[1]),
        ]
      end
      let!(:variants) do
        [
          create(:variant, option_values: [colors[0]]),
          create(:variant, option_values: [colors[1]]),
          create(:variant, option_values: [sizes[0]]),
          create(:variant, option_values: [sizes[1]]),
          create(:variant, option_values: [colors[1], sizes[1]]),
        ]
      end
      let!(:products) do
        [
          create(:product, taxons: [taxon], variants: [variants[0]]),
          create(:product, taxons: [taxon], variants: [variants[1]]),
          create(:product, taxons: [taxon], variants: [variants[2]]),
          create(:product, taxons: [taxon], variants: [variants[3]]),
          create(:product, taxons: [taxon], variants: [variants[4]]),
        ]
      end

      # params[:color]が存在する時、@productsにcolorフィルターがかかっているか
      it "has @products filtered by color when params[:color] exists" do
        get :show, params: { id: taxon.id, color: "Red" }
        expect(assigns(:products)).to include(products[0])
        expect(assigns(:products)).not_to include(products[1])
        expect(assigns(:products)).not_to include(product_not_has_taxon)
      end

      # params[:size]が存在する時、@productsにsizeフィルターがかかっているか
      it "has @products filtered by size when params[:size] exists" do
        get :show, params: { id: taxon.id, size: "Small" }
        expect(assigns(:products)).to include(products[2])
        expect(assigns(:products)).not_to include(products[3])
        expect(assigns(:products)).not_to include(product_not_has_taxon)
      end

      # params[:color]、params[:size]の両方が存在する時、@productsにcolorとsizeフィルターがかかっているか
      it "has @products filtered by color & size when params[:color] & params[:size] exist" do
        get :show, params: { id: taxon.id, color: "Blue", size: "Medium" }
        expect(assigns(:products)).to include(products[4])
        expect(assigns(:products)).not_to include(products[1])
        expect(assigns(:products)).not_to include(products[3])
        expect(assigns(:products)).not_to include(product_not_has_taxon)
      end
    end

    describe "filters_by_sort" do
      context "order_by_available_on" do
        let!(:products) do
          [
            create(:product, taxons: [taxon], available_on: Date.current.in_time_zone),
            create(:product, taxons: [taxon], available_on: 1.day.ago),
            create(:product, taxons: [taxon], available_on: 1.week.ago),
          ]
        end

        it "is ordered by descending available_on when params[:sort] is NEW_PRODUCTS" do
          get :show, params: { id: taxon.id, sort: "NEW_PRODUCTS" }
          expect(assigns(:products)).to match(products)
        end

        it "is ordered by ascending available_on when params[:sort] is OLD_PRODUCTS" do
          get :show, params: { id: taxon.id, sort: "OLD_PRODUCTS" }
          expect(assigns(:products)).to match(products.reverse)
        end
      end

      context "order_by_price" do
        let!(:products) do
          [
            create(:product, taxons: [taxon], price: 10.00),
            create(:product, taxons: [taxon], price: 20.00),
            create(:product, taxons: [taxon], price: 30.00),
          ]
        end

        it "is ordered by ascending price when params[:sort] is LOW_PRICE" do
          get :show, params: { id: taxon.id, sort: "LOW_PRICE" }
          expect(assigns(:products)).to match(products)
        end

        it "is ordered by descending price when params[:sort] is HIGH_PRICE" do
          get :show, params: { id: taxon.id, sort: "HIGH_PRICE" }
          expect(assigns(:products)).to match(products.reverse)
        end
      end
    end
  end
end
