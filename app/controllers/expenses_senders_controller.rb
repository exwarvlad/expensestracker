class ExpensesSendersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_expenses_sender, only: [:edit, :update]

  def edit
    @expenses_ids = params[:expenses]
    respond_to do |f|
      f.html
      f.js { render template: 'expenses_senders/edit' }
    end
  end

  def update
    @expenses_sender = ExpensesSenderService.update(@expenses_sender, expenses_sender_params, expenses_ids)
    respond_to do |f|
      if @expenses_sender.errors.empty? && verify_recaptcha(model: @expenses_sender)
        SenderToEmailWorker.perform_async(@expenses_sender.email, current_user.id, expenses_ids)
        flash.now[:notice] = "Expenses pages successful deliver to #{@expenses_sender.email}"
        f.js { render template: 'expenses_senders/update' }
      else
        f.js { render template: 'expenses_senders/update_errors' }
      end
    end
  end

  private

  def set_expenses_sender
    @expenses_sender = current_user.expenses_sender
  end

  def expenses_sender_params
    params.require(:expenses_sender).permit(:email)
  end

  def expenses_ids
    Filter.check_expenses(@expenses_sender.user.id).ids
  end
end