class SurveysCompaniesController < ApplicationController

  def index
    @companies = Company.where("name LIKE(?)","%#{params[:keyword]}%")
  end

  def create
    @survey = Survey.find(params[:survey_id])
    create_params[:company_ids].each do |company_id|
      @survey.surveys_company.create(company_id: company_id)
    end
    render '/surveys/(params[:survey_id])'
  end


  private

  def create_params
    params.permit(:survey_id, company_ids:[])
  end
end
