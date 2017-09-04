class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_header_content

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password, :password_confirmation, :company_id, :image, :image_cache])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email, :password, :password_confirmation,:image, :image_cache])
  end

  def set_header_content
    if current_admin
      @root_path = authenticated_admin_root_path
      @list_item = [{name: "法人一覧", path: admins_companies_path},
        {name: "新規法人登録", path: new_admins_company_path},
        {name: "アンケート一覧", path: admins_surveys_path},
        {name: "アンケート作成", path: new_admins_survey_path},
        {name: "ユーザー設定", path:edit_admin_registration_path},
        {name: "ログアウト", path: destroy_admin_session_path, method: :delete}]
    elsif current_user
        @root_path = authenticated_user_root_path
        @list_item = [{name: "アンケート一覧", path: surveys_path},
         {name: "ユーザー設定", path: edit_user_registration_path},
         {name: "ログアウト", path: destroy_user_session_path, method: :delete}]
        @list_item.push({name: "社員一覧", path: "#"}) if current_user.chief_flag
      else
        @root_path = "#"
      end
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
