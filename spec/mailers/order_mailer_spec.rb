require 'rails_helper'

RSpec.describe Spree::OrderMailer, type: :mailer do
  let!(:order) { create(:order) }
  let!(:product) { create(:product, name: "test") }
  let!(:variant) { create(:variant, product: product) }
  let!(:price) { create(:price, variant: variant, amount: 5.00) }
  let!(:line_item) { create(:line_item, variant: variant, order: order, quantity: 1, price: 4.99) }
  let!(:store) { create(:store, mail_from_address: "store@example.com") }
  let(:mail) { Spree::OrderMailer.confirm_email(order) }

  describe "confirm_email" do
    # 正しい件名・宛先・送信元を反映しているか
    it "renders the headers" do
      expect(mail.subject).to eq("#{order.store.name} Order Confirmation ##{order.number}")
      expect(mail.to).to eq([order.email])
      expect(mail.from).to eq([order.store.mail_from_address])
    end

    # 正しいメール本文を反映しているか
    it "renders the body" do
      expect(mail.body.encoded).to have_content(product.name)
      expect(mail.body.encoded).to have_content(line_item.quantity)
      expect(mail.body.encoded).to have_content(order.display_total)
    end
  end
end
