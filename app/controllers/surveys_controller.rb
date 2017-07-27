class SurveysController < ApplicationController
  before_action :authenticate_admin!, only:[:new, :create]
  def index
  end

  def new
    @survey = Survey.new
    @survey.questions.build
    last_question = Question.last
    @question_id = last_question.id + 1
  end

  def create
    begin
      @survey = Survey.new(survey_params)
      @questions = @survey.questions.new(question_params)
      @choises = QuestionsChoise.new(choises_params) if params[:choises].present?
      ActiveRecord::Base.transaction do
        @survey.save!
        @questions.save!
        @choises.save!
      end
      redirect_to surveys_path
      rescue => e
        render new_survey_path
    end
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
