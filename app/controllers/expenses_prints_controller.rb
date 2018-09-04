class ExpensesPrintsController < ApplicationController
  def print
    @expenses = Filter.check_expenses(current_user.id)
    respond_to do |format|
      format.html
      format.js { render template: 'expenses_prints/print' }
    end
  end
end
