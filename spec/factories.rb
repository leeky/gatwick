FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  sequence :event_name do |n|
    "Event ##{n}"
  end

  sequence :name do |n|
    "Name ##{n}"
  end

  sequence :eventbrite_barcode do |n|
    sprintf("%010d", n)
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

  factory :attendee do
    event
    name { generate(:name) }
    eventbrite_barcode { generate(:barcode) }
  end
end
