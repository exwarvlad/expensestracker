module ExpensesHelper
  class DisplacementCalculator
    attr_reader :expense, :position, :exp_of_prev_page

    def initialize(expense, expenses)
      @expense = expense
      @position = expenses.find_index(@expense)

      if @position.nil?
        @expense = nil
        @exp_of_prev_page = expenses.last
      end
    end
  end
end
