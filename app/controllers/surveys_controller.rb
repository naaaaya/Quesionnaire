class SurveysController < ApplicationController

  def index
  end

  def new
    @survey = Survey.new
    @survey.questions.build
    last_question = Question.last
    @question_id = last_question.id + 1
  end

  def create
    @survey = Survey.create(survey_params)
    @question = @survey.questions.create(question_params)
    QuestionsChoise.create(choises_params) if params[:choises].present?
    redirect_to surveys_path
  end

  private

  def survey_params
    params.require(:survey).permit(:title, :description)
  end

  def question_params
    params.require(:questions).map { |u| u.permit(:description, :question_type) }
  end

  def choises_params
    params.require(:choises).map { |u| u.permit(:description, :question_id) }
  end
end
