require 'faker'

FactoryGirl.define do
  factory :text_answer do
    description Faker::Lorem.sentence
  end
end