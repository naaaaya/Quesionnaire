class Question < ApplicationRecord
  belongs_to :survey
  enum question_type: { text_field: 0, textarea: 1, checkbox: 2, radio_button: 3 }
end
