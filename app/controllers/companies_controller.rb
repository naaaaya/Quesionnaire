class CompaniesController < ApplicationController

  def index
    @companies = Company.all
  end

  def new
    @company = Company.new
    @chief = @company.users.build
  end

  def create
    Company.create(company_params)
    redirect_to action: 'index'
  end

  def show
    @company = Company.find(params[:id])
  end


  private

  def company_params
    params.require(:company).permit(:name)
  end
end
