class Question < ApplicationRecord
  belongs_to :survey
  has_many :questions_choises, dependent: :destroy
  has_many :text_answers, dependent: :destroy
  has_many :choise_answers, dependent: :destroy
  enum question_type: { 'text_field': 0, 'textarea': 1, 'checkbox': 2, 'radio_button': 3 }
  validates :description, presence: true
  TEXT_FIELD = 0
  TEXTAREA = 1
  CHECKBOX = 2
  RADIO_BUTTON = 3

  def is_answered?(user)
    surveys_user = SurveysUser.find_by(survey_id:survey_id, user_id: user.id)
    return false if surveys_user.nil?
    case question_type
    when 'text_field', 'textarea'
      surveys_user.text_answers.find_by(question_id: id).present?
    when 'checkbox', 'radio_button'
      surveys_user.choise_answers.find_by(question_id: id).present?
    end
  end


  def self.create_question(survey, question_params)
    question = survey.questions.create!(description: question_params[:description], question_type: question_params[:question_type])
    choises_params = question_params[:choises]
    QuestionsChoise.create_choises(question, choises_params) if choises_params
  end

  def self.edit_question(question_params)
    question = Question.find(question_params[:id])
    choises_params = question_params[:choises]
    if question.question_type != question_params[:question_type]
      previous_choises = question.questions_choises
      previous_choises.destroy! if previous_choises.present?
      QuestionsChoise.create_choises(question, choises_params) if choises_params
    else
      QuestionsChoise.edit_choises(question, choises_params) if choises_params
    end
    question.update!(description: question_params[:description], question_type: question_params[:question_type])
  end

  def overall_choise_answers_for_chart
    surveys_users = choise_answers.map{|answer| answer.surveys_user}.select{|surveys_user| surveys_user.answered_flag}.map{|surveys_user| surveys_user.id}.uniq
    answers = choise_answers.where(surveys_user_id: surveys_users)
    answers.group(:questions_choise_id).count.map {|key,val| [QuestionsChoise.find(key).description,val]}.to_h
  end

  def company_choise_answers_for_chart(company)
    surveys_users = company.users.map{|user|user.surveys_users.find_by(survey_id: survey.id, answered_flag:1)}.map{|surveys_user| surveys_user.try(:id)}.compact!
    choise_answers_per_inc = choise_answers.where(surveys_user_id: surveys_users)
    choise_answers_per_inc.group(:questions_choise_id).count.map {|key,val| [QuestionsChoise.find(key).description,val]}.to_h
  end

end
