class Admins::SurveysController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_survey, only:[:show, :edit, :update, :destroy]
  before_action :unlist_survey, only: :update
  def index
    @draft_surveys = Survey.where(status: 0)
    @published_surveys = Survey.where(status: 1)
    @unlisted_surveys = Survey.where(status: 2)
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
        if question_params[:choises]
          choises_params = question_params[:choises]
          choises_params.each do |choise_params|
            @choises << question.questions_choises.new(choise_params)
          end
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
      redirect_to admins_surveys_path
    rescue => e
      render new_admins_survey_path
    end
  end

  def show
    @added_companies = @survey.companies
    @surveys_company = @survey.surveys_companies.build
    @questions = @survey.questions
  end

  def edit
    @questions = @survey.questions
  end

  def update
    begin
      ActiveRecord::Base.transaction do
        @survey.update(survey_params)
        @questions = []
        questions_edit_params.each do |question_params|
          question = Question.find(question_params[:id])
          question.update(description: question_params[:description], question_type: question_params[:question_type])
          question_params[:choises].each do |choise_params|
            choise = QuestionsChoise.find(choise_params[:id])
            choise.update(choise_params)
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
      @survey.update(status: 2)
      redirect_to admins_surveys_path
    end
  end

  def survey_params
    params.require(:survey).permit(:title, :description)
  end

  def questions_params
    params.require(:questions).map { |u| u.permit(:description, :question_type, choises: [%w(description)]) }
  end

  def questions_edit_params
    params.require(:questions).map { |u| u.permit(:id, :description, :question_type, choises: [%w(id description)]) }
  end

  def set_survey
    survey_id = params[:id]
    @survey = Survey.find(params[:id])
  end
end
