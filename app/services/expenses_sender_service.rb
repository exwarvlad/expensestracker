module ExpensesSenderService
  class << self
    def update(expenses_sender, expenses_sender_params, expenses_params)
      if expenses_params.empty?
        expenses_sender.errors.add(:base, 'send is nothing')
      else
        expenses_sender.update(expenses_sender_params)
      end
      expenses_sender
    end
  end
end