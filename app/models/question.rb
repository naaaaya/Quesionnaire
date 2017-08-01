class Question < ApplicationRecord
  belongs_to :survey
  has_many :questions_choises
  enum question_type: { '自由記述（短文回答）': 0, '自由記述（長文回答）': 1, 'チェックボックス': 2, 'ラジオボタン': 3 }
  validates :description, presence: true
end
