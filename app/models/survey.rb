class Survey < ApplicationRecord
  has_many :questions
  has_many :surveys_companies
  enum status: { '下書き': 0, '公開': 1, '非公開': 2 }
  validates :title, presence: true
end
