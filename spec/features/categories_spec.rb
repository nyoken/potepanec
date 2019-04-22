require 'rails_helper'

RSpec.feature "Categories", type: :feature do
  let(:taxnomy) { create(:taxnomy, name: "TestTaxnomy") }

  scenario "User accesses show page from root URL" do
    visit potepan_category_path(taxnomy.id)
    within '.media-body' do
      expect(page).to have_content taxnomy.name
    end
  end
end
