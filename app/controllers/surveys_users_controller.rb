class SurveysUsersController < ApplicationController
  before_action :set_survey, only:[:new, :create]
  before_action :authenticate_user!, only:[:new, :create]

  def new
    redirect_to surveys_path if SurveysUser.try(:find_by, user_id: current_user, survey_id: params[:survey_id]).try(:answered_flag)
    @surveys_user = @survey.surveys_users.build
  end

  def create
    redirect_to surveys_path if SurveysUser.try(:find_by, user_id: current_user, survey_id: params[:survey_id]).try(:answered_flag)
    begin
      ActiveRecord::Base.transaction do
        create_or_update_surveys_user
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
      end
      redirect_to surveys_path
    rescue => e
      @questions = @survey.questions
      render new_survey_surveys_user
    end
  end

  def set_survey
    @survey_id = params[:survey_id]
    @survey = Survey.find(@survey_id)

    redirect_to surveys_path unless @survey.status = Survey::PUBLISHED

  end

  private

  def create_or_update_surveys_user
    case params[:commit]
    when '下書き保存'
      @surveys_user = @survey.surveys_users.where(user_id: current_user.id).first_or_initialize
    when '回答する'
      @surveys_user = @survey.surveys_users.where(user_id: current_user.id).first_or_initialize
      @surveys_user.answered_flag = true
      return @surveys_user
    end
    @surveys_user.save!
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
    answer_params
  end

  def create_or_update_text_answer(answer_param)
    text_answer = @surveys_user.text_answers.where(question_id: answer_param[:question_id]).first_or_initialize
    text_answer.description = answer_param[:description]
    text_answer.save!
  end

  def create_or_update_checkbox_answer(answer_param)
    answer_param[:choise_ids].each do |choise_id|
      choise_answer = @surveys_user.choise_answers.where(question_id: answer_param[:question_id], questions_choise_id: choise_id).first_or_initialize
      choise_answer.save!
    end
  end

  def delete_unchecked_choise_answer(checked_ids, answer_param)
    checked_ids.each do |checked_id|
      delete_choise_answer = @surveys_user.choise_answers.find_by(questions_choise_id: checked_id) unless answer_param[:choise_ids].include?(checked_id.to_s)
      delete_choise_answer.destroy!
    end
  end

  def create_or_update_radio_answer(answer_param)
    choise_answer = @surveys_user.choise_answers.where(question_id: answer_param[:question_id]).first_or_initialize
    choise_answer.questions_choise_id = answer_param[:questions_choise_id]
    choise_answer.save!
  end

end
