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
      @survey = Survey.new(survey_params)
      ActiveRecord::Base.transaction do
        @survey.save!
        questions_params.each do |question_params|
          create_question(question_params)
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
        @survey.update(survey_params)
        questions_params.each do |question_params|
          if question_params[:id]
            edit_question(question_params)
          else
            create_question(question_params)
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
    params.require(:questions).map { |u| u.permit(:id, :description, :question_type, choises: [%w(id description)]) }
  end

  def create_question(question_params)
    question = @survey.questions.create!(description: question_params[:description], question_type: question_params[:question_type])
    choises = question_params[:choises]
    if choises
      choises.each do |choise_params|
        choise = question.questions_choises
        choise.create!(choise_params)
      end
    end
  end

  def create_choises(question_params)
    question = Question.find(question_params[:id])
    choises = question_params[:choises]
    if choises
      choises.each do |choise_params|
        choise = question.questions_choises
        choise.create!(choise_params)
      end
    end
  end

  def edit_choises(question_params)
    question = Question.find(question_params[:id])
    choises = question_params[:choises]
    if choises
      choises.each do |choise_params|
        choise = QuestionsChoise.find(choise_params[:id])
        choise.update!(choise_params)
      end
    end
  end

  def edit_question(question_params)
    question = Question.find(question_params[:id])
    if question.question_type != question_params[:question_type]
      question.try(:questions_choises).map{|choise| choise.destroy!}
      create_choises(question_params)
    else
      edit_choises(question_params)
    end
    question.update!(description: question_params[:description], question_type: question_params[:question_type])
  end

  def set_survey
    survey_id = params[:id]
    @survey = Survey.find(params[:id])
  end
end
