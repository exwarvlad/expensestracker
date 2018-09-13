module ExpensesHelper
  # calculate expense and table tr:position
  class ExpensePositionCalculator
    attr_reader :expense, :position

    def initialize(expense, expenses, current_page, max_position)
      @expense = expense
      @expenses = expenses.where.not(id: @expense.id)
      @current_page = current_page
      @max_position = max_position
      result = call_back_out_of_range
      return if result
      calculate
    end

    def visible?
      @position.present? ? true : false
    end

    protected

    def call_back_out_of_range
      if @expenses.page(@current_page).out_of_range?
        if @expenses.page(@current_page)
          @exp_created_at = @expense.created_at.to_date
          calculate_at_prev_page
          true
        else
          true
        end
      end
    end

    def calculate
      @exp_created_at = @expense.created_at.to_date
      @date_start = @expenses.page(@current_page).first.created_at.to_date
      @date_end = @expenses.page(@current_page).last.created_at.to_date

      if @expenses.page(@current_page).first_page? && @exp_created_at >= @date_start
        @position = 0
      elsif @exp_created_at >= @date_start
        calculate_at_prev_page
      elsif @exp_created_at < @date_end
        calculate_at_next_page
      else
        @position = @expenses.page(@current_page).find_index { |exp| exp.created_at.to_date == @exp_created_at }
      end
    end

    def calculate_at_prev_page
      prev_page_exp = @expenses.page(@expenses.page(@current_page).prev_page).last

      if prev_page_exp.created_at.to_date > @exp_created_at
        @position = 0
      else
        @position = 0
        @expense = prev_page_exp
      end
    end

    def calculate_at_next_page
      if @expenses.page(@current_page).last_page?
        return @position = @expenses.page(@current_page).size
      end

      next_page_exp = @expenses.page(@expenses.page(@current_page).next_page).first

      if next_page_exp.created_at.to_date < @exp_created_at
        @position = @max_position
      else
        @position = false
      end
    end
  end
end
