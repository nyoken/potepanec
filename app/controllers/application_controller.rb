class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def after_sign_in_path_for(*)
    request.referer
  end

  def after_sign_out_path_for(*)
    potepan_root_path
  end
end
