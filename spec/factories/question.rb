require 'faker'

FactoryGirl.define do
  factory :question do
    description { Faker::Name.title }
    question_type { Question.question_types.keys.to_a[Faker::Number.between(0, 3)] }
  end
end