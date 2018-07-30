class Expense < ApplicationRecord
  paginates_per 10

  MIN_LENGTH = 1
  MAX_LENGTH = 25

  # validates :name, length: { in: MIN_LENGTH..MAX_LENGTH }

  # check current currency
  def currency
    ActionController::Base.helpers.number_to_currency(
      amount, unit: '$', delimiter: '.', format: '%n %u'
    )
  end

  # check current total sum
  def self.total_sum
    ActionController::Base.helpers.number_to_currency(
      Expense.pluck(:amount).sum, unit: '$', delimiter: '.', format: '%n %u'
    )
  end
end
