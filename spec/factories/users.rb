FactoryGirl.define do
  factory :user do
    firstname Faker::Name.first_name
    lastname Faker::Name.last_name
    username { Faker::Internet.user_name } # put in a block to reevaluate and avoid problems on duplicates
    password Faker::Internet.password
  end
end
