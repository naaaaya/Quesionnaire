class SurveysController < ApplicationController
  before_action :authenticate_admin!, only:[:new, :create]
  def index
  end

  def new
    @survey = Survey.new
    @survey.questions.build
  end

  def create
    begin
      @survey = Survey.new(survey_params)
      @questions = []
      @choises = []
      questions_params.each do |question_params|
        question = @survey.questions.new(description:question_params[:description], question_type:question_params[:question_type])
        @questions << question
        choises_params = question_params[:choises]
        choises_params.each do |choise_params|
          @choises << question.questions_choises.new(choise_params)
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

  private

  def survey_params
    params.require(:survey).permit(:title, :description)
  end

  def questions_params
    params.require(:questions).map { |u| u.permit(:description, :question_type, choises: [%w(description)]) }
  end

  def choises_params
    question_params.require(:questions).permit(choises: [%w(description)])
  end
end
