class Question < ApplicationRecord
  belongs_to :survey
  has_many :questions_choises
  has_many :text_answers
  has_many :choise_answers
  enum question_type: { 'text_field': 0, 'textarea': 1, 'checkbox': 2, 'radio_button': 3 }
  validates :description, presence: true

  def is_answered?(user)
    surveys_user = SurveysUser.find_by(survey_id:self.survey_id, user_id: user.id)
    return false if surveys_user.nil?
    case self.question_type
    when 'text_field', 'textarea'
      surveys_user.text_answers.find_by(question_id: self.id).present?
    when 'checkbox', 'radio_button'
      surveys_user.choise_answers.find_by(question_id: self.id).present?
    end
  end

end
