module ParamsMutator
  def without_currency(params)
    params.delete(:currency_attributes)
    params
  end
end