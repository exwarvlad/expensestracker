class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :expenses
  has_one :filter
  has_one :currency_convert
  before_create :build_default_filter

  private

  def build_default_filter
    self.filter = Filter.new(data: Filter::DEFAULT_DATA_PARAMS)
  end
end
