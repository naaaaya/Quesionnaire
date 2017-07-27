class Company < ApplicationRecord
  has_many :users
  has_many :surveys_companies
  validates :name, presence: true
end
