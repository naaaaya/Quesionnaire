class SurveysCompaniesController < ApplicationController

  def index
    @searched_companies = Company.where("name LIKE(?)","%#{params[:keyword]}%")
  end

  def create
    begin
      survey_id = params[:survey_id]
      @survey = Survey.find(survey_id)
      @surveys_companies = []
      create_params[:company_ids].each do |company_id|
        surveys_company = @survey.surveys_company.new(company_id: company_id)
        @surveys_companies << surveys_company
      end
      ActiveRecord::Base.transaction do
        @survey.update!(status: 1)
        @surveys_companies.each do |surveys_company|
          surveys_company.save!
        end
      end
      redirect_to survey_path(survey_id)
    rescue Exception => e
      redirect_to survey_path(survey_id)
    end
  end


  private

  def create_params
    params.permit(:survey_id, company_ids:[])
  end
end
