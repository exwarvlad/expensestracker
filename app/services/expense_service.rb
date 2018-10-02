module ExpenseService
  class << self
    def create(expense_params, user_id)
      begin
        expense = Expense.new(expense_params)
      rescue ArgumentError
        expense = Expense.new(without_currency(expense_params))
        expense.valid?
        expense.errors.add(:currency, 'invalid name')
        return expense
      end
      expense.user_id = user_id
      expense.save
      expense
    end

    def update(expense, expense_params)
      begin
        expense.update(expense_params)
      rescue ArgumentError
        # https://stackoverflow.com/questions/10995972/get-validation-error-messages-without-saving#10996090
        expense.valid? # need for update errors
        expense.errors.add(:currency, 'invalid name')
      end
      expense
    end

    private

    include ParamsMutator
  end
end