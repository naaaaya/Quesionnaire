require 'faker'

FactoryGirl.define do
  factory :questions_choise do
    description Faker::Lorem.sentence
  end
end