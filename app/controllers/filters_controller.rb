class FiltersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_filter, only: [:update, :reset]

  extend FilterService

  def update
    if @filter.update(FilterService.filter_params(params, Currency.names.keys))
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'Filters successfully updated.' }
      end
    else
      redirect_to root_path, alert: 'Filters have unless values'
      # format.html { redirect_to root_path }
    end
  end

  def reset
    if @filter.update(Filter::DEFAULT_PARAMS)
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'Filters successfully reset.' }
      end
    else
      format.html { redirect_to root_path, alert: 'Filters have unless values' }
    end
  end

  private

  def filter_params
    FilterService.filter_params(params, Currency.names.keys)
  end

  def set_filter
    @filter = User.find(current_user.id).filter
  end

  def data_filter_params
    params[:filter][:data][:amount][:start] = params[:data][:amount][:start].to_f
    params.require(:data) {}
  end

  def currency_filter_params
    FilterService.set_params(params, Currency.names.keys)
  end
end