class SurveysController < ApplicationController
  before_action :authenticate_admin!, only:[:new, :create]
  def index
    @surveys = Survey.all
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
      @questions = []
      @choises = []
      questions_params.each do |question_params|
        @questions << @survey.questions.new(question_params)
      end
      if params[:choises].present?
        choises_params.each do |choise_params|
          @choises << QuestionsChoise.new(choise_params)
        end
      end
      ActiveRecord::Base.transaction do
        @survey.save!
        @questions.each do |question|
          question.save!
        end
        @choises.each do |choise|
          choise.save!
        end
      end
      redirect_to surveys_path
    rescue => e
      render new_survey_path
    end
  end

  def show
    @survey = Survey.find(params[:id])
    @companies = Company.all
    @surveys_company = @survey.surveys_companies.new
  end

  private

  def survey_params
    params.require(:survey).permit(:title, :description)
  end

  def questions_params
    params.require(:questions).map { |u| u.permit(:description, :question_type) }
  end

  def choises_params
    params.require(:choises).map { |u| u.permit(:description, :question_id) }
  end
end
