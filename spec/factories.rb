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
  end

  factory :event do
    user
    name { generate(:event_name) }
  end
end
