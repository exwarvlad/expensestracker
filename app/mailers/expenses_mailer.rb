class ExpensesMailer < ApplicationMailer
  def pages(email, user_id, expenses)
    @expenses = Expense.order(created_at: :desc).where(user_id: user_id, id: expenses)
    mail(to: email, subject: 'Expenses pages')
  end
end
