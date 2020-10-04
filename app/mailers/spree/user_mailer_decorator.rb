Spree::UserMailer.class_eval do
  # def reset_password_instructions(user, token, *_args)
  #   current_store_id = _args.inject(:merge)[:current_store_id]
  #   @current_store = Spree::Store.find(current_store_id) || Spree::Store.current
  #   @locale = @current_store.has_attribute?(:default_locale) ? @current_store.default_locale : I18n.default_locale
  #   I18n.locale = @locale if @locale.present?
  #   @edit_password_reset_url = potepan_reset_password_edit_url(reset_password_token: token, host: @current_store.url)
  #   @user = user
  #   mail to: user.email, from: from_address, subject: @current_store.name + ' ' + I18n.t(:subject, scope: [:devise, :mailer, :reset_password_instructions])
  # end
  # def reset_password_instructions(user, token, *_args)
  #   if Rails.env == 'production'
  #     host = "https://sample-store-solidus.herokuapp.com"
  #   else
  #     host = "http://localhost:4000"
  #   end
  #   @store = Spree::Store.default
  #   @edit_password_reset_url = "#{host}/potepan/reset_password/edit?reset_password_token=#{token})"
  #   mail to: user.email, from: from_address(@store), subject: "#{@store.name} #{I18n.t(:subject, scope: [:devise, :mailer, :reset_password_instructions])}"
  # end

  def reset_password_instructions(user, token, *_args)
    @store = Spree::Store.default
    if Rails.env.production?
      host = "https://sample-store-solidus.herokuapp.com/potepan"
    else
      host = "http://localhost:4000"
    end
    @edit_password_reset_url = "#{host}/potepan/reset_password/edit?reset_password_token=#{token}"
    mail to: user.email, from: from_address(@store), subject: "#{@store.name} #{I18n.t(:subject, scope: [:devise, :mailer, :reset_password_instructions])}"
  end
end
