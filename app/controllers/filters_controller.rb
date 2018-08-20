class FiltersController < ApplicationController
  before_action :set_filter, only: :update
  before_action :serialize_currency_to_i, only: :update

  def update
    if @filter.update(data: data_filter_params, currency_attributes: currency_filter_params)
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'Filters successfully updated.' }
      else
        format.html { redirect_to root_path, notice: 'Filters have unless values' }
      end
    end
  end

  private

  def set_filter
    @filter = User.find(current_user.id).filter
  end

  def data_filter_params
    params.require(:data) {}
  end

  def currency_filter_params
    params.require(:currency).permit(:name)
  end

  def serialize_currency_to_i
    params[:currency][:name] = params[:currency][:name].to_i
  end
end
