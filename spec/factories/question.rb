require 'faker'

FactoryGirl.define do
  factory :question do
    description Faker::Lorem.sentence
    question_type 0
  end
end