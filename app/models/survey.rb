class Survey < ApplicationRecord
  has_many :questions
  has_many :companies, through: :surveys_company
  has_many :surveys_company
  enum status: { '下書き': 0, '公開': 1, '非公開': 2 }
  validates :title, presence: true
end
