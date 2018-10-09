FactoryBot.define do
  factory :currency do
    name 0

    association :filter
    association :expense
  end
end