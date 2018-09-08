class ExpensesMailer < ApplicationMailer
  def pages(email, user_id, expenses)
    @expenses = Expense.order(created_at: :desc).where(user_id: user_id, id: expenses)
    user = User.find(user_id)
    @total_amount = user.currency_convert.convert_with_pick(@expenses)
    @convert_currency = user.currency_convert.convert_currency
    mail(to: email, subject: 'Expenses pages')
  end
end
