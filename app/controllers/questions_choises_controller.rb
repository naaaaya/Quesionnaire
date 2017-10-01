class QuestionsChoisesController < ApplicationController
  before_action :authenticate_admin!
  def destroy
    @choise = QuestionsChoise.find(params[:id])
    @choise.destroy
    redirect_to edit_admins_survey_path(params[:survey_id])
  rescue => e
    render edit_admins_survey_path
  end
end
