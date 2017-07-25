class Survey < ApplicationRecord
  has_many :questions
  enum status: { draft: 0, published: 1, unlisted: 2 }
end
