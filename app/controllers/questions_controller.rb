class QuestionsController < ApplicationController
  before_action :authenticate_admin!, only: :destroy

  def destroy
    @question = Question.find(params[:id])
    @survey = @question.survey
    begin
      @question.destroy
      redirect_to edit_admins_survey_path(@survey)
    rescue => e
      logger.error
      render edit_admins_survey_path(@survey)
    end
  end

end
