class SenderToEmailWorker
  include Sidekiq::Worker

  def perform(email, user_id, expenses)
    ExpensesMailer.pages(email, user_id, expenses).deliver_now
  end
end
