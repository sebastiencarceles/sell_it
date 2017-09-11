FactoryGirl.define do
  factory :classified do
    user
    title Faker::Lorem.sentence
    price Faker::Number.number(3)
    description Faker::Lorem.paragraph
  end
end