# calculate displacement expenses position after destroy
class DisplacementDestroyer
  attr_reader :expense

  def initialize(expenses, current_page)
    return if current_page.nil?
    @expenses = expenses
    @current_page = current_page
    call_back_exp_of_next_page
  end

  private

  def call_back_exp_of_next_page
    next_page = @expenses.page(@current_page).next_page
    if next_page.present?
      @expense = @expenses.page(next_page).first
    end
  end
end