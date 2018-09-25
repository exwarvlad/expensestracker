class Expense < ApplicationRecord
  belongs_to :user
  has_one :currency, as: :currencyable
  accepts_nested_attributes_for :currency, update_only: true

  PAGINATE_PREV = 10
  MIN_LENGTH = 1
  MAX_LENGTH = 25

  paginates_per PAGINATE_PREV

  validates :name, length: { in: MIN_LENGTH..MAX_LENGTH }
  validate :date_range

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

  private
  def date_range
    errors.add(:created_at, 'T') if unless_created_at?
  end

  def unless_created_at?
    false
  end
end