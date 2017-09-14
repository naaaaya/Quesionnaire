class QuestionsChoise < ApplicationRecord
  belongs_to :question
  has_many :choise_answers, dependent: :destroy

  def edit_choise(choise_params)
    update!(choise_params)
  end
end
