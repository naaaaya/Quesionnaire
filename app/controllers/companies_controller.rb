class CompaniesController < ApplicationController

  def index
    @companies = Company.all
  end

  def new
    @company = Company.new
    @user = @company.users.build
  end

  def create
    @company = Company.create(company_params)
    @company.users.create(user_params)
    redirect_to action: 'index'
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
