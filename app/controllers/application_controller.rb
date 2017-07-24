class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password, :password_confirmation])
  end

  def after_sign_in_path_for(resource)
    case resource
    when Admin
      authenticated_admin_root_path
    when User
      authenticated_user_root_path
    end
  end

  def after_sign_out_path_for(resource)
    case resource
    when :user
      new_user_session_path
    when :admin
      new_admin_session_path
    end
  end




end
