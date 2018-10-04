module FilterService
  class << self
    def update(filter, filter_params)
      begin
        filter.update(filter_params)
      rescue ArgumentError
        filter.valid?
        filter.errors.add(:currency, 'invalid name')
      end
      filter
    end
  end
end