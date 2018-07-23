class Expense < ApplicationRecord
  MIN_LENGTH = 1
  MAX_LENGTH = 22

  # validates :name, length: { in: MIN_LENGTH..MAX_LENGTH }
end
