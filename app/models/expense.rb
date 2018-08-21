class Expense < ApplicationRecord
  belongs_to :user
  # has_one :currency, as: :currencyable
  paginates_per 10

  MIN_LENGTH = 1
  MAX_LENGTH = 25

  # before_create :build_currency
  validates :name, length: { in: MIN_LENGTH..MAX_LENGTH }

  # check current currency
  def current_currency
    ActionController::Base.helpers.number_to_currency(
      amount, unit: currency.name, delimiter: ' ', format: '%n %u'
    )
  end

  # check current total sum
  def self.total_sum(user_id)
    ActionController::Base.helpers.number_to_currency(
      Filter.check_expenses(user_id).pluck(:amount).sum, unit: '$', delimiter: ' ', format: '%n %u'
    )
  end

  def build_currency(params)
    self.associable = associable_type.constantize.new(params)
  end

  private

  # def build_currency
  #   self.currency = Currency.new(currency_type: self.class)
  # end
end