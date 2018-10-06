class Expense < ApplicationRecord
  belongs_to :user
  has_one :currency, as: :currencyable
  accepts_nested_attributes_for :currency, update_only: true

  PAGINATE_PREV = 10
  MIN_LENGTH = 1
  MAX_LENGTH = 42
  CREATED_AT_START = Date.today - 100.year
  CREATED_AT_END = Date.today.end_of_day

  paginates_per PAGINATE_PREV

  validates :name, length: { in: MIN_LENGTH..MAX_LENGTH }
  validates :expense_type, length: { in: MIN_LENGTH..MAX_LENGTH }
  validates :amount, presence: true,
                     numericality: { greater_than: 0, less_than: 1000000 },
                     format: { with: /\A\d+(?:\.\d{0,2})?\z/ }
  validates :currency, presence: true
  validates :user, presence: true
  validate :date_rangeable?

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

  def date_rangeable?
    return errors.add(:created_at, 'created at must be date') if created_at.nil?
    range = CREATED_AT_START...CREATED_AT_END
    date = created_at.to_date
    errors.add(:created_at, "is missing range date #{error_message_date(date)}") unless range.include?(date)
  end

  def error_message_date(date)
    if date < CREATED_AT_START
      "(must be >= #{CREATED_AT_START.strftime('%B %d, %Y')})"
    elsif date > CREATED_AT_END
      "(must be <= #{CREATED_AT_END.strftime('%B %d, %Y')})"
    end
  end
end