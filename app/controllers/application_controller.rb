class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :devise_parameter_sanitizer, if: :devise_controller?

  protected

  def devise_parameter_sanitizer
    if resource_class == User
      UserParameterSanitizer.new(User, :user, params)
    else
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password, :password_confirmation])
    end
  end

end
