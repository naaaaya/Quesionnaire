class Company < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :surveys, through: :surveys_companies
  has_many :surveys_companies
  validates :name, presence: true
end
