class Admins::CompaniesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_company, only: [:show, :edit, :update, :destroy]

  def index
    @companies = Company.all
  end

  def new
    @company = Company.new
    @user = @company.users.build
  end

  def create
    begin
      ActiveRecord::Base.transaction do
        @company = Company.create!(company_params)
        @user = @company.users.create!(user_params)
      end
      redirect_to admins_companies_path
    rescue => e
      binding.pry
      render new_admins_company_path
    end
  end

  def show
    @company = Company.find(params[:id])
  end

  def edit
  end

  def update
    if @company.update(company_params)
      redirect_to admins_companies_path
    else
      @error_messages = @company.errors.full_messages
      render 'admins/companies/edit'
    end
  end



  def destroy
    begin
      ActiveRecord::Base.transaction do
        @company = Company.find(params[:id])
        @company.destroy
      end
      redirect_to admins_companies_path
    rescue => e
      render admins_companies_path
    end
  end


  private

  def company_params
    params.require(:company).permit(:name)
  end

  def user_params
    params.require(:company).permit(user: [:name, :email, :password, :password_confirmation]).require(:user).merge(chief_flag: true)
  end

  def set_company
    @company = Company.find(params[:id])
  end
end

