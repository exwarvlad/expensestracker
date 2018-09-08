class ApplicationController < ActionController::Base
  # before_action :configure_permitted_parameters, if: :devise_controller?
  #
  # def configure_permitted_parameters
  #   update_attrs = [:email, :password, :password_confirmation, :current_password]
  #   devise_parameter_sanitizer.permit :account_update, keys: update_attrs
  # end
end
