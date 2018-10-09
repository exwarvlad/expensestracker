FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "expenses_tracker_supporter_#{n}@example.com" }
    after(:build) { |u| u.password_confirmation = u.password = '123123' }
  end
end