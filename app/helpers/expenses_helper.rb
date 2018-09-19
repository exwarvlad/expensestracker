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
      'to be continue...'
    end
  end
end