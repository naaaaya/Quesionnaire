class SurveysController < ApplicationController
  before_action :authenticate_user!

  def index
    @answered_surveys = current_user.surveys_users.answered
    @draft_surveys = current_user.surveys_users.drafts
    @unanswered_surveys = current_user.company.surveys.where(status: 1).never_answered(current_user)
  end

  def show
    users_have_no_authentication = !current_user.chief_flag && !SurveysUser.try(:find_by, user_id: current_user, survey_id: params[:id]).try(:answered_flag)
    redirect_to surveys_path if users_have_no_authentication
    @survey = Survey.find(params[:id])
  end
end
