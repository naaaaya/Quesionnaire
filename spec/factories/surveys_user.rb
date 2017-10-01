require 'faker'

FactoryGirl.define do
  factory :surveys_user do
    association :survey
    association :user
  end
end