class CurrencyConvert
  attr_reader :convert_currency
  RATE_INFO_URL = 'https://api.privatbank.ua/p24api/pubinfo?json&exchange&coursid=5'

  def initialize(expenses, convert_currency)
    @total_bank = Hash.new(0)
    @convert_currency = convert_currency
    expenses.each_with_object(@total_bank).each { |e, h| h[e.currency.name] += e.amount }
  end

  def transfer_transit
    @total_amount = 0

    @total_bank.each do |currency, currency_amount|
      if currency == @convert_currency
        @total_amount += currency_amount
      else
        @exchange_rates ||= goto_rates
        @total_amount += one_amount_to_convert(currency.upcase) * currency_amount
      end
    end
    @total_amount
  end

  def delete_amount_from_expense(amount, currency)
    if currency == @convert_currency
      @total_amount -= amount
    else
      @total_amount -= one_amount_to_convert(currency.upcase) * amount
    end
  end

  def edit_amount_from_expense(expense_before_edit, expense_after_edit)
    if expense_before_edit.currency.name == @convert_currency
      before_amount = expense_before_edit.amount
    else
      before_amount = one_amount_to_convert(expense_before_edit.currency.name.upcase) * expense_before_edit.amount
    end

    if expense_after_edit[:currency] == @convert_currency
      edit_amount = expense_after_edit[:amount]
    else
      edit_amount = one_amount_to_convert(expense_after_edit[:currency].upcase) * expense_after_edit[:amount]
    end
    residual = edit_amount - before_amount
    @total_amount -= residual
  end

  def new_amount_from_expense(amount, currency)
    # byebug
    if currency == @convert_currency
      @total_amount += amount
    else
      @total_amount += one_amount_to_convert(currency.upcase) * amount
    end
  end

  private

  def goto_rates
    response = HTTParty.get(RATE_INFO_URL)
    JSON(response.body, symbolize_names: true)
  end

  def one_amount_to_convert(currency)
    if @convert_currency == 'grn' && currency == 'BTC'
      return btc_to_grn
    elsif @convert_currency == 'grn'
      current_rate = @exchange_rates.find { |h| h[:ccy] == currency }
      return current_rate[:buy].to_f
    end

    @convert_currency_rate ||= check_currency_rate(@convert_currency.upcase)

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
      current_rate = @exchange_rates.find { |h| h[:ccy] == currency }
      current_rate[:buy].to_f
    end
  end

  def btc_to_grn
    btc_to_usd = @exchange_rates.find { |h| h[:ccy] == 'BTC' }
    usd_to_grn = @exchange_rates.find { |h| h[:ccy] == 'USD' }
    usd_to_grn[:buy].to_f * btc_to_usd[:buy].to_f
  end
end