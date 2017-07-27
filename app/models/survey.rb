class Survey < ApplicationRecord
  has_many :questions
  enum status: { '下書き': 0, '公開': 1, '非公開': 2 }
  validates :title, presence: true
end
