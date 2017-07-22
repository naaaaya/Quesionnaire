class Admins::CompaniesController < ApplicationController

  def index
    @companies = Company.all
  end

  def new
    @company = Company.new
    @company.users.build
  end

  def create
    begin
      @company = Company.new(company_params)
      @user = @company.users.new(user_params)
      ActiveRecord::Base.transaction do
        @company.save!
        @user.save!
      end
      redirect_to :action => 'index'
    rescue => e
      render :action => 'new'
    end
  end

  def show
    @company = Company.find(params[:id])
  end


  private

  def company_params
    params.require(:company).permit(:name)
  end

  def user_params
    params.require(:company).permit(user:[:name, :email,:password, :password_confirmation]).require(:user).merge(chief_flag: true)
  end
end
