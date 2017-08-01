class Company < ApplicationRecord
  has_many :users
  has_many :surveys, through: :surveys_company
  belongs_to :surveys_company
  validates :name, presence: true
end
