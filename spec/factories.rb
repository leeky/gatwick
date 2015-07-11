FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  sequence :event_name do |n|
    "Event ##{n}"
  end

  factory :user do
    email
    password "password"

    trait :eventbrite_authenticated do
      eventbrite_token "dummy"
    end
  end

  factory :event do
    user
    name { generate(:event_name) }
  end
end
