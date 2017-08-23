class SurveysController < ApplicationController
  before_action :authenticate_user!

  def index
    @answered_surveys = current_user.surveys_users.answered
    @draft_surveys = current_user.surveys_users.drafts
    @unanswered_surveys = Survey.never_answered(current_user)
  end

  def show
    redirect_to surveys_path if current_user.chief_flag == false && SurveysUser.try(:find_by, user_id: current_user, survey_id: params[:id]).try(:answered_flag) == false
    @survey = Survey.find(params[:id])
    @questions = @survey.questions
    @users = current_user.company.users
  end
end
