
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
    choise_answers_description = questions_choises.joins(:choise_answers).pluck(:id, :description).to_h
    choise_answers_ids = choise_answers.joins(:surveys_user).merge(SurveysUser.where(answered_flag: true)).pluck(:id).uniq
    choise_answers.where(id:choise_answers_ids).group(:questions_choise_id).count.map {|key,val| [choise_answers_description[key],val]}.to_h
  end

  def company_choise_answers_for_chart(company)
    choise_answers_description = questions_choises.joins(:choise_answers).pluck(:id, :description).to_h
    choise_answers_ids = choise_answers.joins(:surveys_user).merge(SurveysUser.joins(:user).merge(User.where(company_id:company.id))).pluck(:id).uniq
    choise_answers.where(id:choise_answers_ids).group(:questions_choise_id).count.map {|key,val| [choise_answers_description[key],val]}.to_h
  end

end
