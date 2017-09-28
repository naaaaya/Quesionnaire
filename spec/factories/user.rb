require 'faker'

FactoryGirl.define do
  factory :user do
    association :company
    email { Faker::Internet.email }
    name { Faker::Name.name }
    password '000000'
    password_confirmation '000000'
  end
end