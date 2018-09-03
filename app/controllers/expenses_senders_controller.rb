class ExpensesSendersController < ApplicationController
  before_action :set_expenses_sender, only: [:edit, :update]
  def edit
    @expenses_ids = params[:expenses]
    respond_to do |f|
      f.html
      f.js {render template: 'expenses_senders/edit'}
    end
  end

  def update
    # return respond_to { |f| f.js { flash.now[:notice] = 'Expenses pages have unless values' } }
    if @expenses_sender.update(expenses_sender_params) && verify_recaptcha(model: @expenses_sender)
      SenderToEmailWorker.perform_async(@expenses_sender.email, current_user.id, expenses_parms)
      respond_to do |f|
        f.js { flash.now[:notice] = "Expenses pages successful deliver to #{@expenses_sender.email}" }
      end
    else
      render :edit
    end
  end

  private

  def set_expenses_sender
    @expenses_sender = current_user.expenses_sender
  end

  def expenses_sender_params
    params.require(:expenses_sender).permit(:email)
  end

  def expenses_parms
    params.require(:expenses).split(' ').map(&:to_i)
  end
end