require 'rails_helper'

RSpec.describe Potepan::LineItemsController, type: :controller do
  let!(:store) { create(:store) }

  describe 'destroy' do
    let!(:line_item) { create(:line_item) }

    it 'destroies a line_item' do
      expect(Spree::LineItem.count).to eq(1)
      delete :destroy, params: { id: line_item.id }
      expect(Spree::LineItem.count).to eq(0)
    end
  end
end
