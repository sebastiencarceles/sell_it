FactoryGirl.define do
  factory :user do
    fullname Faker::Name.name
    username Faker::Internet.user_name
    password Faker::Internet.password
  end
end
