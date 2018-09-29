class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :expenses
  has_one :filter
  has_one :currency_convert
  has_one :expenses_sender
  before_create :build_default_filter
  before_create :build_expenses_sender

  private

  def build_default_filter
    self.filter = Filter.new(data: Filter::DEFAULT_PARAMS)
  end

  def build_expenses_sender
    self.expenses_sender = ExpensesSender.new(email: current_user.email)
  end
end
