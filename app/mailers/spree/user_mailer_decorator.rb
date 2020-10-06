Spree::UserMailer.class_eval do
  def reset_password_instructions(user, token, *_args)
    @store = Spree::Store.default
    if Rails.env.production?
      host = "https://sample-store-solidus.herokuapp.com/potepan"
    elsif Rails.env.development?
      host = "http://localhost:4000"
    else
      host = "http://www.example.com"
    end
    @edit_password_reset_url = "#{host}/potepan/reset_password/edit?reset_password_token=#{token}"
    mail to: user.email, from: from_address(@store), subject: "#{@store.name} #{I18n.t(:subject, scope: [:devise, :mailer, :reset_password_instructions])}"
  end
end
