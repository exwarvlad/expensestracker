module ExpensesHelper
  # receive @expenses page before and initialize @expenses after
  # compares their expenses page and calculate expense with position for create and for destroy
  class DisplacementCalculator
    attr_reader :for_adds, :for_removes

    def initialize(expenses_before, expenses_after)
      @expenses_before = expenses_before
      @expenses_after = expenses_after
      @expenses_create = expenses_after - expenses_before
      @expenses_destroy = expenses_before - expenses_after
    end

    def add_for_creates
      @for_adds ||= [] # [[position, expense]...]
      expenses_create_ids = @expenses_create.map(&:id)
      @expenses_after.each_with_index { |exp, index| @for_adds << {position: index, exp: exp} if expenses_create_ids.include?(exp.id) }
    end

    def add_for_removes
      @for_removes ||= []
      @for_removes |= @expenses_destroy.map(&:id)
    end

    def add_for_edit_per_page(expense)
      expense_index_before = @expenses_before.find_index { |exp| exp.id == expense.id }
      expense_index_after = @expenses_after.find_index { |exp| exp.id == expense.id }

      if expense_index_before == expense_index_after
        { position: expense_index_before, remove_position: false }
      elsif expense_index_after.present?
        { position: expense_index_after, remove_position: expense_index_before }
      else
        false
      end
    end
  end
end