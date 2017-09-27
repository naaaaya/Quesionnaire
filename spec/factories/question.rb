require 'faker'

FactoryGirl.define do
  factory :question do
    description Faker::Name.title
    question_type 0
  end
end