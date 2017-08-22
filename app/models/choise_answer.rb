class ChoiseAnswer < ApplicationRecord
  belongs_to :question
  belongs_to :surveys_user
  belongs_to :questions_choise
  validates :question_id,  uniqueness: { scope: [:questions_choise_id, :surveys_user_id]  }
end
