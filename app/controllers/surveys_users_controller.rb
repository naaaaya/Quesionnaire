class SurveysUsersController < ApplicationController
  before_action :set_survey, only:[:new, :create]

  def new
    @surveys_user = @survey.surveys_users.new
    @questions = @survey.questions
  end

  def create
    begin
      case params[:commit]
      when '下書き保存'
        @surveys_user = @survey.surveys_users.new(user_id: current_user.id)
      when '回答する'
        @surveys_user = @survey.surveys_users.new(user_id: current_user.id, answered_flag: true)
      end
      text_answers = []
      choise_answers = []
      create_params.each do |answer_param|
        question = Question.find(answer_param[:question_id])
        case question.question_type
        when 'text_field', 'textarea'
          text_answers << @surveys_user.text_answers.new(answer_param)
        when 'checkbox'
          answer_param[:choise_ids].each do |choise_id|
            choise_answers << @surveys_user.choise_answers.new(question_id: answer_param[:question_id], questions_choise_id: choise_id)
          end
        when 'radio_button'
          choise_answers << @surveys_user.choise_answers.new(answer_param)
        end
      end
      ActiveRecord::Base.transaction do
        @surveys_user.save!
        text_answers.each do |answer|
          answer.save!
        end
        choise_answers.each do |answer|
          answer.save!
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
    return answer_params
  end
end
