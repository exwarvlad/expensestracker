require 'rails_helper'

RSpec.describe Expense, type: :model do
  let(:user) { FactoryBot.create(:user) }

  context 'validate' do
    it '.date_rangeable?' do
      # must be grater or equal Expense::CREATED_AT_START
      expect { FactoryBot.create(:expense,
                                 user_id: user.id,
                                 currency_attributes: { name: 0 },
                                 created_at: Expense::CREATED_AT_START - 1.second)
      }.to raise_error

      # must be latter or equal Expense::CREATED_AT_END
      expect { FactoryBot.create(:expense,
                                 user_id: user.id,
                                 currency_attributes: { name: 0 },
                                 created_at: Expense::CREATED_AT_END + 1.second)
      }.to raise_error
    end
  end
end
