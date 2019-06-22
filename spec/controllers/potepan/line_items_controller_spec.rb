require 'rails_helper'

RSpec.describe Potepan::LineItemsController, type: :controller do
  let!(:store) { create(:store) }

  describe 'create' do
    let!(:variant) { create(:variant) }

    it 'creates new line_item object' do
      expect(Spree::LineItem.count).to eq(0)
      post :create, params: { line_item: { quantity: 1 }, variant_id: variant.id }
      expect(Spree::LineItem.count).to eq(1)
    end
  end

  describe 'destroy' do
    let!(:line_item) { create(:line_item) }

    it 'destroies a line_item' do
      expect(Spree::LineItem.count).to eq(1)
      delete :destroy, params: { id: line_item.id }
      expect(Spree::LineItem.count).to eq(0)
    end
  end
end
