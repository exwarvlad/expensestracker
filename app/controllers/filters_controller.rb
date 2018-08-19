class FiltersController < ApplicationController
  before_action :set_filter, only: :update

  def update
    if @filter.update(data: data_filter_params)
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
end
