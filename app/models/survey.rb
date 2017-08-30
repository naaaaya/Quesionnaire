class Survey < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :companies, through: :surveys_companies
  has_many :users, through: :surveys_users

  has_many :surveys_companies
  has_many :surveys_users
  enum status: { 'draft': 0, 'published': 1, 'unlisted': 2 }
  DRAFT = 0
  PUBLISHED = 1
  UNLISTED = 2
  has_many :surveys_companies, dependent: :destroy
  has_many :surveys_users, dependent: :destroy
  validates :title, presence: true
  scope :never_answered, -> (user){ where.not(["exists (select id from surveys_users where surveys.id = surveys_users.survey_id and surveys_users.user_id = ? and surveys.status = 1) ", user.id])}


end
