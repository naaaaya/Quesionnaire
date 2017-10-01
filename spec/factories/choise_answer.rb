require 'faker'

FactoryGirl.define do
  factory :choise_answer do
    association :surveys_user
    association :question
    association :questions_choise
  end
end