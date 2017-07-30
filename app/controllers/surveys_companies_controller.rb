class SurveysCompaniesController < ApplicationController

  def create
    @survey = Survey.find(params[:survey_id])
    create_params[:company_ids].each do |company_id|
      @survey.surveys_companies.create(company_id: company_id)
    end
    render survey_path
  end


  private

  def create_params
    params.require(:surveys_company).permit(company_ids:[])
  end
end
