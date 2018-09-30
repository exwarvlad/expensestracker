module ExpenseService
  class << self
    def create(expense_params, user_id)
      begin
        @expense = Expense.new(expense_params)
      rescue ArgumentError
        @expense = Expense.new(expense_without_currency(expense_params))
      end
      @expense.user_id = user_id
      @expense
    end

    private

    def expense_without_currency(expense_params)
      expense_params.delete(:currency_attributes)
      expense_params
    end
  end
end