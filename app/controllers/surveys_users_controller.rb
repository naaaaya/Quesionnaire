class SurveysUsersController < ApplicationController
  before_action :set_survey, only:[:new, :create]
  before_action :redirect_to_index, only:[:new, :create]
  before_action :set_arrays, only: :create
  before_action :authenticate_user!, only:[:new, :create]

  def new
    @surveys_user = @survey.surveys_users.includes([:text_answers, :choise_answers]).where(survey_id:params[:survey_id], user_id:current_user.id).new
    @questions = @survey.questions.page(params[:page]).per(10)
  end

  def create
    begin
      @surveys_user = create_or_update_surveys_user
      create_params.each do |answer_param|
        question = Question.find(answer_param[:question_id])
        case question.question_type
        when 'text_field', 'textarea'
          create_or_update_text_answer(answer_param)
        when 'checkbox'
          checked_ids = question.choise_answers.where(surveys_user_id: @surveys_user.id).map{ |answer| answer.questions_choise.id }
          delete_unchecked_choise_answer(checked_ids, answer_param)
          create_or_update_checkbox_answer(answer_param)
        when 'radio_button'
          create_or_update_radio_answer(answer_param)
        end
      end
      ActiveRecord::Base.transaction do
        @surveys_user.save!
        @text_answers.each do |answer|
          answer.save!
        end
        @choise_answers.each do |answer|
          answer.save!
        end
        @delete_choise_answers.each do |answer|
          answer.destroy!
        end
      end
      redirect_to redirect_path
    rescue => e
      @questions = @survey.questions
      render new_survey_surveys_user_path
    end
  end

  def set_survey
    @survey_id = params[:survey_id]
    @survey = Survey.includes(:surveys_users).find(@survey_id)
  end

  def redirect_path
    case params[:commit]
    when '下書き保存', '回答する'
      return surveys_path
    when '前の10件'
      previous_page = params[:current_page].to_i - 1
      path = "#{new_survey_surveys_user_path}/?page=#{previous_page}"
      return path
    when '次の10件'
      next_page = params[:current_page].to_i + 1
      path = "#{new_survey_surveys_user_path}/?page=#{next_page}"
      return path
    end
  end

  def set_arrays
    @text_answers = []
    @choise_answers = []
    @delete_choise_answers = []
  end

  def redirect_to_index
    redirect_to surveys_path if SurveysUser.find_by(user_id: current_user, survey_id: params[:survey_id]) && SurveysUser.find_by(user_id: current_user, survey_id: params[:survey_id]).answered_flag
  end

  private

  def create_or_update_surveys_user
    case params[:commit]
    when '前の10件', '次の10件', '下書き保存'
      @surveys_user = @survey.surveys_users.where(user_id: current_user.id).first_or_initialize
    when '回答する'
      @surveys_user = @survey.surveys_users.where(user_id: current_user.id).first_or_initialize
      @surveys_user.answered_flag = true
      return @surveys_user
    end
  end

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
    return answer_params
  end

  def create_or_update_text_answer(answer_param)
    text_answer = @surveys_user.text_answers.where(question_id: answer_param[:question_id]).first_or_initialize
    text_answer.description = answer_param[:description]
    @text_answers << text_answer
  end

  def create_or_update_checkbox_answer(answer_param)
    answer_param[:choise_ids].each do |choise_id|
      @choise_answers << @surveys_user.choise_answers.where(question_id: answer_param[:question_id], questions_choise_id: choise_id).first_or_initialize
    end
  end

  def delete_unchecked_choise_answer(checked_ids, answer_param)
    checked_ids.each do |checked_id|
      @delete_choise_answers << @surveys_user.choise_answers.find_by(questions_choise_id: checked_id) unless answer_param[:choise_ids].include?(checked_id.to_s)
    end
  end

  def create_or_update_radio_answer(answer_param)
    choise_answer = @surveys_user.choise_answers.where(question_id: answer_param[:question_id]).first_or_initialize
    choise_answer.questions_choise_id = answer_param[:questions_choise_id]
    @choise_answers << choise_answer
  end

end
