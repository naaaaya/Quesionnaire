class UsersController < ApplicationController
  before_action :authenticate_user!, only:[:index, :destroy]
  before_action :authenticate_admin!, only:[:change_chief]
  before_action :set_user, only: [:destroy, :change_chief]
  def index
    redirect_to authenticated_user_root_path unless current_user.chief_flag
    @company = current_user.company
  end

  def destroy
    begin
      ActiveRecord::Base.transaction do
        @user.destroy!
      end
      redirect_to users_path
    rescue  => e
    end
  end

  def change_chief
    @company = @user.company
    @chief = @company.users.find_by(chief_flag: true)

    begin
      ActiveRecord::Base.transaction do
        @chief.update!(chief_flag: false)
        @user.update!(chief_flag: true)
      end
      redirect_to admins_company_path(@company)
    rescue => e
      render admins_company_path(@company)
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

end
