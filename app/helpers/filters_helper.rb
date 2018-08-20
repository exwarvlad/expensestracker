module FiltersHelper
  def round_amount(amount)
    amount.present? ? '%.2f' % amount : ''
  end

  class CurrencyNames
    attr_reader :names, :current_name

    def initialize(current_name)
      @names = Currency.names.dup
      @names.delete(current_name)
      @current_name = current_name
    end
  end
end
