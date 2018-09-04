class ExpensesPrintsController < ApplicationController
  before_action :authenticate_user!

  def print
    @expenses = Filter.check_expenses(current_user.id)
    @total_amount = current_user.currency_convert.convert_with_pick(@expenses)
    @convert_currency = current_user.currency_convert.convert_currency
    respond_to do |format|
      format.js { render template: 'expenses_prints/print' }
    end
  end
end
