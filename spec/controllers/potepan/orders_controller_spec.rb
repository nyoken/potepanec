require 'rails_helper'

RSpec.describe Potepan::OrdersController, type: :controller do
  let!(:store) { create(:store) }

  describe "edit" do
    let!(:order) { create(:order, guest_token: "abcde") }

    before do
      cookies.signed[:guest_token] = "abcde"
      get :edit
    end

    # 正常にレスポンスを返すか
    it "responds successfully" do
      expect(response).to be_successful
    end

    # edit.html.erbが描画されているか
    it "render show view" do
      expect(response).to render_template :edit
    end

    it "has correct @order" do
      expect(assigns(:order)).to eq order
    end
  end

  describe 'add_cart' do
    let!(:variant) { create(:variant) }

    it 'creates new line_item object' do
      expect(Spree::LineItem.count).to eq(0)
      post :add_cart, params: { line_item: { quantity: 1 }, variant_id: variant.id }
      expect(Spree::LineItem.count).to eq(1)
    end
  end

  describe 'update' do
    let!(:order)     { create(:order_with_line_items) }
    let!(:line_item) { order.line_items.first }
    let :order_params do
      {
        order: {
          line_items_attributes: {
            quantity: 2, id: line_item.id,
          },
        },
        number: line_item.order.number,
      }
    end

    it 'changes line_item quantity' do
      expect(line_item.quantity).to eq(1)
      patch :update, params: order_params
      line_item.reload
      expect(line_item.quantity).to eq(2)
    end

    it 'updates item total' do
      expect(order.item_total).to eq(BigDecimal('10.00'))
      patch :update, params: order_params
      order.reload
      expect(order.item_total).to eq(BigDecimal('20.00'))
    end
  end
end
