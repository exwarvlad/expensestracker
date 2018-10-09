require 'rails_helper'

RSpec.describe Filter, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:exp) { FactoryBot.create(:expense, user_id: user.id, currency_attributes: { name: 0 }) }

  context '.verify_amount_finish' do
    it 'start not be grater finish' do
      data_filter = user.filter.data
      data_filter['duration'] = Filter.date_to_s(Date.today - 30.day...Date.today.end_of_day)
      data_filter['amount']['start'] = 42
      data_filter['amount']['finish'] = 41

      expect(user.filter.update(data: data_filter)).to be false
    end
  end

  context '.verify_date_range' do
    it '.verify_given_string_date' do
      data_filter = user.filter.data
      valid_date_keys = DateQueryCalculator::DATE_RANGES.keys # Today, Yesterday ...

      valid_date_keys.each do |key|
        # parse date key to date_string_format for save
        date_range = Filter.check_duration_range(key)
        string_date_format = Filter.date_to_s(date_range)
        data_filter['duration'] = string_date_format
        expect(user.filter.update(data: data_filter)).to be true
      end

      # next expect invalid date keys
      expect { Filter.check_duration_range(:invalid_key) }.to raise_error
    end

    it '.verify_custom_range' do
      # date end must be letter or equal Expense::CREATED_AT_END years
      data_filter = user.filter.data
      invalid_custom_range = Filter.date_to_s(Date.today...Expense::CREATED_AT_END + 1.second)
      data_filter['duration'] = invalid_custom_range
      expect(user.filter.update(data: data_filter)).to be false

      # date start must be grater or equal Expense::CREATED_AT_START year
      invalid_custom_range = Filter.date_to_s(Expense::CREATED_AT_START - 1.second...Date.today)
      data_filter['duration'] = invalid_custom_range
      expect(user.filter.update(data: data_filter)).to be false
    end

    it 'invalid request' do
      data_filter = user.filter.data
      invalid_date_range = 'invalid date range'
      data_filter['duration'] = invalid_date_range
      expect(user.filter.update(data: data_filter)).to be false
    end
  end
end