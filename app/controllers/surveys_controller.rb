class SurveysController < ApplicationController
  before_action :authenticate_user!

  def index
    @answered_surveys = current_user.surveys_users.answered
    @draft_surveys = current_user.surveys_users.drafts
    @unanswered_surveys = current_user.company.surveys.where(status: Survey.statuses[:published]).never_answered(current_user)
  end

  def show
    @survey = Survey.includes(questions: [{questions_choises: :choise_answers}, :text_answers]).find(params[:id])
    users_have_no_authentication = !current_user.chief_flag && !SurveysUser.try(:find_by, user_id: current_user, survey_id: @survey.id).try(:answered_flag) || current_user.chief_flag && !SurveysCompany.try(:find_by, company_id: current_user.company, survey_id: @survey.id )
    redirect_to surveys_path if users_have_no_authentication
  end
end
