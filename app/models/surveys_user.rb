class SurveysUser < ApplicationRecord
  has_many :text_answers
  has_many :choise_answers
  belongs_to :survey
  belongs_to :user
  validates :survey_id, uniqueness: {scope: :user_id}
  scope :answered, -> { where(answered_flag: true) }
  scope :drafts, -> { where(answered_flag: false) }


end
