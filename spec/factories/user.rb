require 'faker'

FactoryGirl.define do
  factory :user do
    association :company
    password = Faker::Number.number(10)
    email { Faker::Internet.email }
    name { Faker::Name.name }
    password password
    password_confirmation password
  end
end