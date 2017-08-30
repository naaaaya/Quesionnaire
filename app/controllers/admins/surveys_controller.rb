class Admins::SurveysController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_survey, only:[:show, :edit, :update, :destroy]
  before_action :unlist_survey, only: :update
  def index
    @draft_surveys = Survey.where(status: Survey::DRAFT)
    @published_surveys = Survey.where(status: Survey::PUBLISHED)
    @unlisted_surveys = Survey.where(status: Survey::UNLISTED)
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
    @added_companies = @survey.companies
    @surveys_company = @survey.surveys_companies.build
  end

  def edit
    @questions = @survey.questions
  end

  def update
    begin
      ActiveRecord::Base.transaction do
        @survey.update!(survey_params)
        questions_params.each do |question_params|
          if question_params[:id]
            Question.edit_question(question_params)
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
