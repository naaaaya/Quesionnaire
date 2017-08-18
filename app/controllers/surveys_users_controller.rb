class SurveysUsersController < ApplicationController

  def new
    @survey = Survey.find(params[:survey_id])
    @surveys_user = @survey.surveys_users.new
    @questions = @survey.questions
  end

  def create
    binding.pry
  end
end
