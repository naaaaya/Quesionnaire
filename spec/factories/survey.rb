require 'faker'

FactoryGirl.define do
  factory :survey do
    title { Faker::Name.title }
    description { Faker::Lorem.sentence }

    factory :invalid_survey do
      title nil
      description { Faker::Lorem.sentence }
    end
  end
end