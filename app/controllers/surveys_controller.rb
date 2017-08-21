class SurveysController < ApplicationController
  before_action :authenticate_user!

  def index
    @answered_surveys = current_user.surveys_users.answered
    @draft_surveys = current_user.surveys_users.drafts
    @unanswered_surveys = Survey.unanswered(current_user)
  end
end
