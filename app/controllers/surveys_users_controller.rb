class SurveysUsersController < ApplicationController

  def new
    @survey = Survey.find(params[:survey_id])
    @surveys_user = @survey.surveys_users.new
    @questions = @survey.questions
  end

  def create
    survey = Survey.find(params[:survey_id])
    surveys_user = survey.surveys_users.create(user_id: current_user.id)
    create_params.each do |answer_param|
      question = Question.find(answer_param[:id])
      case question.question_type
      when 'text_field', 'textarea'
        surveys_user.text_answers.create(answer_param)
      end
    end
  end

private

  def create_params
    answer_params = []
    params[:surveys_user].each do |question_id, answer|
      case answer[:question_type]
      when 'text_field', 'textarea'
        answer_param = {id: question_id, description: answer[:description]}
        answer_params << answer_param
      when 'checkbox','radio_button'
        answer_param = {id: question_id, answer: answer[:choise_ids]}
        answer_params << answer_param
      end
    end
    return answer_params
  end
end
