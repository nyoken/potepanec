# Preview all emails at http://localhost:4000/rails/mailers/order_mailer
class OrderMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:4000/rails/mailers/order_mailer/confirm_email
  def confirm_email
    order = Spree::Order.create(email: "test@example.com")
    Spree::OrderMailer.confirm_email(order)
  end
end
