class Survey < ApplicationRecord
  has_many :questions
  has_many :companies, through: :surveys_companies
  has_many :users, through: :surveys_users
  has_many :surveys_companies
  has_many :surveys_users
  enum status: { '下書き': 0, '公開': 1, '非公開': 2 }
  validates :title, presence: true
end
