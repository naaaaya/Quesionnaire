class Admins::CompaniesController < ApplicationController
  before_action :authenticate_admin!

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
      redirect_to admins_companies_path
    rescue => e

      @error_messages = []

      @company.errors.full_messages.each do |message|
        @error_messages << message
      end
      @user.errors.full_messages.each do |message|
        @error_messages << message
      end

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
      redirect_to companies_path
    else
      @error_messages = @company.errors.full_messages
      render edit_company_path
    end
  end

  def destroy
    @company.destroy
    redirect_to companies_path
  end


  private

  def company_params
    params.require(:company).permit(:name)
  end

  def user_params
    params.require(:company).permit(user:[:name, :email,:password, :password_confirmation]).require(:user).merge(chief_flag: true)
  end

  def set_company
    @company = Company.find(params[:id])
  end
end

