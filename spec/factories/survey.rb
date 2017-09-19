require 'faker'

FactoryGirl.define do
  factory :survey do
    title Faker::Lorem.sentence
    description Faker::Lorem.paragraph
  end
end