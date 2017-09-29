require 'faker'

FactoryGirl.define do
  factory :admin do
    password = Faker::Number.number(10)
    email { Faker::Internet.email }
    name { Faker::Name.name }
    password password
    password_confirmation password
  end
end