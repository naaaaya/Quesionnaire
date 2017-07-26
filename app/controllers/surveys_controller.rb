class SurveysController < ApplicationController

  def index
  end

  def new
    @survey = Survey.new
    @survey.questions.build
  end

  def create
    @survey = Survey.create(survey_params)
    @question = @survey.questions.create(question_params)
    @question.questions_choises.create(choises_params)

  end

  private

  def survey_params
    params.require(:survey).permit(:title, :description)
  end

  def question_params
    params.require(:question).permit(:description, :question_type)
  end

  def choises_params
    params.require(:choises).map { |u| u.permit(:description) }
  end
end
