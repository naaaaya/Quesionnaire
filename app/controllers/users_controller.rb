class UsersController < ApplicationController
  before_action :authenticate_user!
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
end
