class DeviseWorker
  include Sidekiq::Worker
  # sidekiq_options queue: :mailer

  def perform(devise_mailer, method, user_id, *args)
    user = User.find(user_id)
    devise_mailer.safe_constantize.send(method, user, *args).deliver_now
  end
end
