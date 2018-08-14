class FiltersController < ApplicationController
  before_action :set_filter, only: :update
  before_action :set_duration, only: :update

  def update
    # byebug
    if @filter.update(data: data_filter_params,
                      duration_start: duration_start_param,
                      duration_end: duration_end_param)
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'Filters successfully updated.' }
      end
    end
  end

  private

  def set_filter
    @filter = User.find(current_user).filter
  end

  def data_filter_params
    params.require(:data) {}
  end

  def duration_filter_params
    params.require(:duration) {}
  end

  def set_duration
    @dates = params[:duration].split('-')
  end

  def duration_start_param
    Date.parse(@dates.first)
  end

  def duration_end_param
    Date.parse(@dates.second)
  end
end
