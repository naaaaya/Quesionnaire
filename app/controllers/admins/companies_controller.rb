class Admins::CompaniesController < ApplicationController
  before_action :authenticate_admin!

  def index
    @companies = Company.all
  end

  def new
    @company = Company.new
    @user = @company.users.build
  end

  def create
    begin
      @company = Company.new(company_params)
      @user = @company.users.new(user_params)
      ActiveRecord::Base.transaction do
        @company.save!
        @user.save!
      end
      redirect_to admins_companies_path
    rescue => e
      render new_admins_company_path
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
