class Potepan::UserSessionsController < Devise::SessionsController
  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::Common
  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::Store

  def create
    authenticate_spree_user!

    if spree_user_signed_in?
      respond_to do |format|
        format.html do
          flash[:success] = I18n.t('spree.logged_in_succesfully')
          redirect_back_or_default(after_sign_in_path_for(spree_current_user))
        end
        format.js { render success_json }
      end
    else
      respond_to do |format|
        format.html do
          flash[:error] = t('devise.failure.invalid')
          redirect_to potepan_root_path
        end
        format.js do
          render json: { error: t('devise.failure.invalid') }, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    super
  end
end
