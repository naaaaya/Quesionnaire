class SurveysUsersController < ApplicationController

  before_action :set_survey, only:[:new, :create]
  before_action :authenticate_user!, only:[:new, :create]

  def new
    @questions = @survey.questions.page(params[:page]).per(10)
    redirect_to surveys_path if SurveysUser.try(:find_by, user_id: current_user, survey_id: params[:survey_id]).try(:answered_flag)
    @surveys_user = @survey.surveys_users.build
  end

  def create
    if SurveysUser.exists?(user_id: current_user.id, survey_id: params[:survey_id], answered_flag: true)
      redirect_to surveys_path
    end
    begin
      ActiveRecord::Base.transaction do
        @surveys_user = @survey.get_surveys_user_by_status(params, current_user)
        create_params.each do |answer_params|
          question = Question.find(answer_params[:question_id])
          @surveys_user.create_or_update_answer(answer_params, question)
        end
      end
      redirect_to redirect_path
    rescue => e
      logger.error
      @questions = @survey.questions
      render new_survey_surveys_user_path
    end
  end

  def set_survey
    @survey_id = params[:survey_id]
    @survey = Survey.find(@survey_id)
    redirect_to surveys_path unless @survey.published?
  end

  def redirect_path
    if params[:previous_page]
      previous_page = params[:current_page].to_i - 1
      path = "#{new_survey_surveys_user_path}/?page=#{previous_page}"
      return path
    elsif params[:next_page]
      next_page = params[:current_page].to_i + 1
      path = "#{new_survey_surveys_user_path}/?page=#{next_page}"
      return path
    else
      return surveys_path
    end
  end


  private

  def create_params
    answer_params = []
    params[:surveys_user].each do |question_id, answer|
      case answer[:question_type]
      when 'text_field', 'textarea'
        answer_param = {question_id: question_id, description: answer[:description]}
        answer_params << answer_param
      when 'checkbox'
        answer_param = {question_id: question_id, choise_ids: answer[:choise_ids]}
        answer_params << answer_param
      when 'radio_button'
        answer_param = {question_id: question_id, questions_choise_id: answer[:choise_id]}
        answer_params << answer_param
      end
    end
    answer_params
  end
end
