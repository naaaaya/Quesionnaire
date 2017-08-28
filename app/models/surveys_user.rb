class SurveysUser < ApplicationRecord
  has_many :text_answers, dependent: :destroy
  has_many :choise_answers, dependent: :destroy
  belongs_to :survey
  belongs_to :user
  validates :survey_id, uniqueness: {scope: :user_id}
  scope :answered, -> { where(answered_flag: true) }
  scope :drafts, -> { where(answered_flag: false) }


end
