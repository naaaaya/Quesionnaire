class Admins::SurveysController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_survey, only:[:update, :destroy]
  before_action :unlist_survey, only: :update
  def index
    @draft_surveys = Survey.where(status: Survey.statuses[:draft])
    @published_surveys = Survey.where(status: Survey.statuses[:published])
    @unlisted_surveys = Survey.where(status: Survey.statuses[:unlisted])
  end

  def new
    @survey = Survey.new
    @survey.questions.build
  end

  def create
    begin
      ActiveRecord::Base.transaction do
        @survey = Survey.create!(survey_params)
        questions_params.each do |question_params|
          Question.create_question(@survey, question_params)
        end
      end
      redirect_to admins_surveys_path
    rescue => e
      render new_admins_survey_path
    end
  end

  def show
    @survey = Survey.includes(questions:[{choise_answers: :surveys_user}, {text_answers: :surveys_user}]).find(params[:id])
    @added_companies = @survey.companies
    @surveys_company = @survey.surveys_companies.build
  end

  def edit
    @survey = Survey.includes(questions: :questions_choises).find(params[:id])
    @questions = @survey.questions
  end

  def update
    begin
      ActiveRecord::Base.transaction do
        @survey.update!(survey_params)
        question_ids = questions_params.pluck(:id)
        questions = Question.where(id: question_ids)
        questions_params.zip(questions).each do |question_params, question|
          if question
            question.edit_question(question_params)
          else
            Question.create_question(@survey, question_params)
          end
        end
      end
      redirect_to admins_survey_path(params[:id])
    rescue => e
      render edit_admins_survey_path
    end
  end

  def destroy
    begin
      ActiveRecord::Base.transaction do
        @survey.destroy!
      end
      redirect_to admins_surveys_path
    rescue => e
      redirect_to admins_surveys_path
    end
  end

  private

  def unlist_survey
    if params[:unlist_survey]
      @survey.unlisted!
      redirect_to admins_surveys_path
    end
  end

  def survey_params
    params.require(:survey).permit(:title, :description)
  end

  def questions_params
    params.require(:questions).map { |u| u.permit(:id, :description, :question_type, choises: [%w(id description)]) }
  end

  def set_survey
    @survey = Survey.find(params[:id])
  end
end
