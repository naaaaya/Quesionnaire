require 'faker'

FactoryGirl.define do
  factory :user do
    email Faker::Internet.email
    name Faker::Name
    password '000000'
    password_confirmation '000000'
    company_id Faker::Number.digit
  end
end