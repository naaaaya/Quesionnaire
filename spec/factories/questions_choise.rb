require 'faker'

FactoryGirl.define do
  factory :questions_choise do
    description { Faker::Name.title }
  end
end