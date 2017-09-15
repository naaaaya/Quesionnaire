class SurveysController < ApplicationController
  before_action :authenticate_user!

  def index
    @answered_surveys = current_user.surveys_users.answered
    @draft_surveys = current_user.surveys_users.drafts
    @unanswered_surveys = current_user.company.surveys.where(status: Survey.statuses[:published]).never_answered(current_user)
  end

  def show
    @survey = Survey.includes(questions: [{questions_choises: :choise_answers}, :text_answers]).find(params[:id])
    survey_id = @survey.id
    is_chief = current_user.chief_flag
    is_answered = SurveysUser.try(:find_by, user_id: current_user, survey_id: survey_id).try(:answered_flag)
    is_self_company = SurveysCompany.try(:find_by, company_id: current_user.company, survey_id: survey_id )
    is_answered_user = !is_chief && is_answered
    is_self_company_chief = is_chief && is_self_company
    has_auth = is_answered_user || is_self_company_chief
    redirect_to surveys_path unless has_auth
  end
end
