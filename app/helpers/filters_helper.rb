module FiltersHelper
  def round_amount(amount)
    amount.present? ? '%.2f' % amount : ''
  end
end
