class TextAnswer < ApplicationRecord
  belongs_to :question
  belongs_to :surveys_user
  validates :question_id,  uniqueness: { scope: :surveys_user_id  }
end
