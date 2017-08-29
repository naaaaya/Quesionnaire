class QuestionsChoise < ApplicationRecord
  belongs_to :question
  validates :description, presence: true

  def self.create_choises(question, choises_params)
    choises_params.map{ |choise_params| question.questions_choises.create!(choise_params) } if choises_params
  end

  def self.edit_choises(question, choises_params)
    choises_params.each do |choise_params|
      choise = QuestionsChoise.find(choise_params[:id])
      choise.update!(choise_params)
    end
  end

end
