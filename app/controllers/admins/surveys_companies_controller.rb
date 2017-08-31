class Admins::SurveysCompaniesController < ApplicationController

  def index
    @searched_companies = Company.where("name LIKE(?)","%#{params[:keyword]}%")
  end

  def create
    begin
      survey_id = params[:survey_id]
      @survey = Survey.find(survey_id)
      ActiveRecord::Base.transaction do
        @survey.published!
        create_params[:company_ids].each do |company_id|
          surveys_company = @survey.surveys_companies.create!(company_id: company_id)
        end
      end
      redirect_to admins_survey_path(survey_id)
    rescue Exception => e
      redirect_to admins_survey_path(survey_id)
    end
  end

  private

  def create_params
    params.permit(:survey_id, company_ids:[])
  end
end
