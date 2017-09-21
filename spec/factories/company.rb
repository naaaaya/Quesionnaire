require 'faker'

FactoryGirl.define do
  factory :company do
    name Faker::Lorem.sentence
  end
end