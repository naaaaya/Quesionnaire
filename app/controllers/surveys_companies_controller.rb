class SurveysCompaniesController < ApplicationController

  def index
    @searched_companies = Company.where("name LIKE(?)","%#{params[:keyword]}%")
  end

  def create
    survey_id = params[:survey_id]
    @survey = Survey.find(survey_id)
    create_params[:company_ids].each do |company_id|
      @survey.surveys_company.create(company_id: company_id)
    end
    redirect_to survey_path(survey_id)
  end


  private

  def create_params
    params.permit(:survey_id, company_ids:[])
  end
end
