require 'faker'

FactoryGirl.define do
  factory :user do
    email Faker::Internet.unique.email
    name Faker::Name.name
    password '000000'
    password_confirmation '000000'
  end
end