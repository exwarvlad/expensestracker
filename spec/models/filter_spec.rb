require 'rails_helper'

RSpec.describe Filter, type: :model do
  let(:user) { FactoryBot.create(:user) }

  context '.check_expenses' do
    it 'expense created_at' do
      checked_expenses = Filter.check_expenses(user.id)
      expect(checked_expenses.empty?).to eq true

      # adding expense with valid created_at for Filter
      exp1 = FactoryBot.create(:expense, user_id: user.id, currency_attributes: { name: 0 })
      checked_expenses = Filter.check_expenses(user.id)
      expect(checked_expenses.size).to eq 1
      expect(checked_expenses.first).to eq exp1

      # change prev expense created_at to invalid for filter
      exp1.update(created_at: Date.today - 31.day)
      expect(checked_expenses.empty?).to eq true

      # change filter date range by include exp1
      filter_data = user.filter.data
      filter_data['duration'] = Filter.date_to_s(Date.today - 31.day...Date.today.end_of_day - 1.day)
      user.filter.update(data: filter_data)
      checked_expenses = Filter.check_expenses(user.id)
      expect(checked_expenses.size).to eq 1
      expect(checked_expenses.first).to eq exp1

      # change created_at to grater Filter date range
      exp1.update(created_at: Date.today)
      expect(checked_expenses.empty?).to eq true
    end

    it 'expense rubric' do
      exp1 = FactoryBot.create(:expense, user_id: user.id, currency_attributes: { name: 0 })
      filter_data = user.filter.data
      filter_data['rubric_names'] = 'growth'
      filter_data['duration'] = Filter.date_to_s(Date.today - 30.day...Date.today.end_of_day)
      user.filter.update(data: filter_data)

      checked_expenses = Filter.check_expenses(user.id)
      expect(checked_expenses.empty?).to eq true

      filter_data['rubric_names'] = 'Деградация'
      user.filter.update(data: filter_data)
      checked_expenses = Filter.check_expenses(user.id)
      expect(checked_expenses.first).to eq exp1
    end

    it 'amount range' do
      exp1 = FactoryBot.create(:expense, user_id: user.id, currency_attributes: { name: 0 })
      filter_data = user.filter.data
      filter_data['amount']['start'] = 42
      filter_data['duration'] = Filter.date_to_s(Date.today - 30.day...Date.today.end_of_day)
      user.filter.update(data: filter_data)
      checked_expenses = Filter.check_expenses(user.id)
      expect(checked_expenses.empty?).to eq true

      filter_data['amount']['start'] = 1
      user.filter.update(data: filter_data)
      checked_expenses = Filter.check_expenses(user.id)
      expect(checked_expenses.first).to eq exp1
    end
  end
end
