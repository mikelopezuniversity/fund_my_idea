class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
      keys: [:username, :first_name, :last_name, :email, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:sign_in,
      keys: [:login, :password, :password_confirmation, :uid, :provider, :access_code, :publishable_key])
    devise_parameter_sanitizer.permit(:account_update,
      keys: [:username, :first_name, :last_name, :email, :password, :password_confirmation, :current_password, :uid, :provider, :access_code, :publishable_key])
  end
end
