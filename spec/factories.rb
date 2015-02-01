require 'faker'

Faker::Config.locale = 'en-GB'

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password "password"
    password_confirmation "password"
    # an admin user
    factory :admin do
      admin true
    end
  end
end

FactoryGirl.define do
  factory :customer do
    code { Faker::Lorem.characters(6) }
    name { Faker::Company.name }
    address { Faker::Address.street_address true }
    postcode { Faker::Address.postcode }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
  end
end

FactoryGirl.define do
  factory :delivery do
    user
    customer
    date "2014-09-08"
    precedence 1
    complete "2014-09-08 11:20:59"
    travel_time 1
  end
end