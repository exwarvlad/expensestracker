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
    it 'verify_given_string_date' do
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
  end
end