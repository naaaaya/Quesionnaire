class QuestionsChoise < ApplicationRecord
  belongs_to :question
  has_many :choise_answers, dependent: :destroy
  validates :description, presence: true
end
