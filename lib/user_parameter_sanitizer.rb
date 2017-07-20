class UserParameterSanitizer < Devise::ParameterSanitizer
  def sign_up
    default_params.require(:user).permit(:name, :email, :password, :password_confirmation)
    defalul_params.require(:companies).permit(:name)
  end
end