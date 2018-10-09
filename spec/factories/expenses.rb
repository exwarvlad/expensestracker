FactoryBot.define do
  factory :expense do
    name { 'Билет на концерт Фараона' }
    amount { 1 }
    expense_type { 'Деградация' }
    created_at { Date.today }
  end
end