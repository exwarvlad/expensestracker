FactoryBot.define do
  factory :filter do
    data { Filter::DEFAULT_PARAMS }

    association :user
  end
end