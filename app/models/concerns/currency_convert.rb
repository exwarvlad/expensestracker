class CurrencyConvert
  attr_accessor :convert_currency
  RATE_INFO_URL = 'https://api.privatbank.ua/p24api/pubinfo?json&exchange&coursid=5'

  def initialize(expenses, convert_currency)
    @total_bank = Hash.new(0)
    @convert_currency = convert_currency
    expenses.each_with_object(@total_bank).each { |e, h| h[e.currency.name] += e.amount }
  end

  def transfer_transit
    total_amount = 0

    @total_bank.each do |currency, currency_amount|
      if currency == @convert_currency
        total_amount += currency_amount
      else
        @exchange_rates ||= goto_rates
        total_amount += one_amount_to_convert(currency.upcase) * currency_amount
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
    if @convert_currency == 'grn'
      current_rate = @exchange_rates.find { |h| h[:ccy] == currency }
      return current_rate[:buy].to_f
    end

    @convert_currency_rate ||= check_currency_rate(@convert_currency.upcase)

    if currency == 'GRN'
      1 / @convert_currency_rate
    else
      currency_rate = check_currency_rate(currency)
      currency_rate / @convert_currency_rate
    end
  end

  def check_currency_rate(currency)
    if currency == 'BTC'
      btc_to_usd = @exchange_rates.find { |h| h[:ccy] == 'BTC' }
      usd_to_grn = @exchange_rates.find { |h| h[:ccy] == 'USD' }
      usd_to_grn[:buy].to_f * btc_to_usd[:buy].to_f
    else
      current_rate = @exchange_rates.find { |h| h[:ccy] == currency }
      current_rate[:buy].to_f
    end
  end
end