class UsersController < ApplicationController
  before_action :authenticate_user!, only:[:index, :destroy]
  before_action :authenticate_admin!, only:[:change_chief]
  def index
    redirect_to authenticated_user_root_path unless current_user.chief_flag
    @company = current_user.company
  end

  def destroy
    @user = User.find(params[:id])
    begin
      ActiveRecord::Base.transaction do
        @user.destroy!
      end
      redirect_to users_path
    rescue  => e
    end
  end

  def change_chief
    @user = User.find(params[:id])
    @company = @user.company
    @chief = @company.users.find_by(chief_flag: true)

    begin
      ActiveRecord::Base.transaction do
        @chief.update!(chief_flag: false)
        @user.update!(chief_flag: true)
      end
      redirect_to admins_company_path(@company)
    rescue => e
      redirect_to admins_company_path(@company)
    end
  end
end
