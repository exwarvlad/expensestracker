class ExpensesMailer < ApplicationMailer
  def pages(email, user_id, expenses)
    @expenses = Expense.where(user_id: user_id, id: expenses)
    mail(to: email, subject: 'Expenses pages')
  end
end
