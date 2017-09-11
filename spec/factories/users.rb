FactoryGirl.define do
  factory :user do
    fullname Faker::Name.name
    username { Faker::Internet.user_name } # put in a block to reevaluate and avoid problems on duplicates
    password Faker::Internet.password
  end
end
