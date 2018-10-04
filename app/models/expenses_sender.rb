class ExpensesSender < ApplicationRecord
  belongs_to :user

  validates :email, presence: true, format: { with: /\A[^@\s]+@[^@\s]+\z/ }
end
