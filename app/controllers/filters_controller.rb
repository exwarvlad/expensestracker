class FiltersController < ApplicationController
  before_action :set_filter, only: :update

  def update
    # byebug
    if @filter.update(filter: filters_params)
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'Filters successfully updated.' }
      end
    end
  end

  private

  def set_filter
    @filter = Filter.find { |f| f.user_id == current_user.id }
  end

  def filters_params
    params.require(:filter) {}
  end
end
