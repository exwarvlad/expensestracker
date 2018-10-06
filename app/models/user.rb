class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :database_authenticatable, :registerable, :omniauthable, omniauth_providers: %i[facebook]

  has_many :expenses
  has_one :filter, inverse_of: :user, dependent: :destroy
  has_one :currency_convert, inverse_of: :user, dependent: :destroy
  has_one :expenses_sender, inverse_of: :user, dependent: :destroy
  before_create :build_default_filter
  before_create :build_expenses_sender

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.password = Devise.friendly_token[0, 20]

      user.email = auth.info.email

      # generate email if invalid
      unless user.valid?
        count = 0
        while user.valid? == false || count != 42
          user.email = "#{rand(99999999999999)}@#{auth.provider}"
          count += 1
        end
      end
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  private

  def build_default_filter
    self.filter = Filter.new(data: Filter::DEFAULT_PARAMS[:data])
    self.filter.currency = Currency.new(Filter::DEFAULT_PARAMS[:currency_attributes])
    self.currency_convert = CurrencyConvert.new(convert_currency: 'usd')
  end

  def build_expenses_sender
    self.expenses_sender = ExpensesSender.new(email: email)
  end
end
