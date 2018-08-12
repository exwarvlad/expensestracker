class Expense < ApplicationRecord
  belongs_to :user
  paginates_per 10

  MIN_LENGTH = 1
  MAX_LENGTH = 25

  before_create :build_user_id

  # validates :name, length: { in: MIN_LENGTH..MAX_LENGTH }
  validates :user, uniqueness: true

  # check current currency
  def currency
    ActionController::Base.helpers.number_to_currency(
      amount, unit: type_amount, delimiter: ' ', format: '%n %u'
    )
  end

  # check current total sum
  def self.total_sum
    ActionController::Base.helpers.number_to_currency(
      Expense.pluck(:amount).sum, unit: '$', delimiter: ' ', format: '%n %u'
    )
  end

  private

  def build_user_id
    self.user_id = current_user.id
  end
end
