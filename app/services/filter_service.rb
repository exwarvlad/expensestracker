module FilterService
  class << self
    def filter_params(params, currency_names)
      set_params = params.require(:filter).permit(data: {}, currency_attributes: [:name])
      set_params = without_currency(set_params) unless currency_names.include?(set_params[:currency_attributes][:name])
      set_params
    end

    private

    include ParamsMutator
  end
end