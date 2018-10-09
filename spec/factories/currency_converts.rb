FactoryBot.define do
  factory :currency_convert do
    convert_currency { 'usd' }

    association :user
  end
end