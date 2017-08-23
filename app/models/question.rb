class Question < ApplicationRecord
  belongs_to :survey
  has_many :questions_choises
  has_many :text_answers
  has_many :choise_answers
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


  def overall_choise_answers_for_chart
    surveys_users = choise_answers.map{|answer| answer.surveys_user}.select{|surveys_user| surveys_user.answered_flag}.map{|surveys_user| surveys_user.id}.uniq
    answers = choise_answers.where(surveys_user_id: surveys_users)
    answers.group(:questions_choise_id).count.map {|key,val| [QuestionsChoise.find(key).description,val]}.to_h
  end

  def company_choise_answers_for_chart(company)
    users = company.users
    surveys_users = users.map{|user|user.surveys_users.find_by(survey_id: survey.id, answered_flag:1)}.map{|surveys_user| surveys_user.try(:id)}.compact!
    choise_answers_per_inc = choise_answers.where(surveys_user_id: surveys_users)
    choise_answers_per_inc.group(:questions_choise_id).count.map {|key,val| [QuestionsChoise.find(key).description,val]}.to_h
  end

end
