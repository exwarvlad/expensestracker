class CurrencyConvert < ApplicationRecord
  belongs_to :user
  attr_accessor :expenses
  RATE_INFO_URL = 'https://api.privatbank.ua/p24api/pubinfo?json&exchange&coursid=5'

  def initialize(attributes={})
    super
    set_total_bank(attributes[:expenses])
  end

  def transfer_transit
    self.total_amount = 0

    self.total_bank.each do |currency, currency_amount|
      if currency == self.convert_currency
        self.total_amount += currency_amount.to_f
      else
        self.exchange_rates = goto_rates
        self.total_amount += one_amount_to_convert(currency.upcase) * currency_amount.to_f
      end
    end
    save
    self.total_amount
  end

  def delete_amount_from_expense(amount, currency)
    if currency == self.convert_currency
      self.total_amount -= amount
    else
      self.total_amount -= one_amount_to_convert(currency.upcase) * amount
    end
  end

  def edit_amount_from_expense(expense_before_edit, expense_after_edit)
    unless Filter.filterable?(expense_before_edit)
      return delete_amount_from_expense(expense_before_edit['amount'], expense_before_edit['currency']['name'])
    end

    if expense_before_edit['currency']['name'] == self.convert_currency
      before_amount = expense_before_edit['amount']
    else
      before_amount = one_amount_to_convert(expense_before_edit['currency']['name'].upcase) * expense_before_edit['amount']
    end

    if expense_after_edit.currency.name == self.convert_currency
      edit_amount = expense_after_edit.amount
    else
      edit_amount = one_amount_to_convert(expense_after_edit.currency.name.upcase) * expense_after_edit.amount
    end
    residual = before_amount - edit_amount
    self.total_amount -= residual
    save
    self.total_amount
  end

  def new_amount_from_expense(amount, currency)
    if currency == self.convert_currency
      self.total_amount += amount
    else
      self.total_amount += one_amount_to_convert(currency.upcase) * amount
    end
    save
    self.total_amount
  end

  def update_bank(expenses, currency_convert)
    self.convert_currency = currency_convert
    set_total_bank(expenses)
    save
  end

  def convert_with_pick(expenses)
    current_bank = Hash.new(0)
    expenses.each_with_object(current_bank).each { |e, h| h[e.currency.name] += e.amount }

    total_amount = 0

    current_bank.each do |currency, currency_amount|
      if currency == self.convert_currency
        total_amount += currency_amount.to_f
      else
        total_amount += one_amount_to_convert(currency.upcase) * currency_amount.to_f
      end
    end
    total_amount
  end

  private

  def goto_rates
    response = HTTParty.get(RATE_INFO_URL)
    JSON(response.body, symbolize_names: true)
  end

  def one_amount_to_convert(currency)
    if self.convert_currency == 'grn' && currency == 'BTC'
      return btc_to_grn
    elsif self.convert_currency == 'grn'
      current_rate = self.exchange_rates.find { |h| h['ccy'] == currency }
      return current_rate['buy'].to_f
    end

    @convert_currency_rate ||= check_currency_rate(self.convert_currency.upcase)

    if currency == 'GRN'
      1.to_f / @convert_currency_rate
    else
      currency_rate = check_currency_rate(currency)
      currency_rate / @convert_currency_rate
    end
  end

  def check_currency_rate(currency)
    if currency == 'BTC'
      btc_to_grn
    else
      current_rate = self.exchange_rates.find { |h| h['ccy'] == currency }
      current_rate['buy'].to_f
    end
  end

  def btc_to_grn
    btc_to_usd = self.exchange_rates.find { |h| h['ccy'] == 'BTC' }
    usd_to_grn = self.exchange_rates.find { |h| h['ccy'] == 'USD' }
    usd_to_grn['buy'].to_f * btc_to_usd['buy'].to_f
  end

  def set_total_bank(expenses)
    total_bank = Hash.new(0)
    expenses.each_with_object(total_bank).each { |e, h| h[e.currency.name] += e.amount }
    self.total_bank = total_bank
  end
end