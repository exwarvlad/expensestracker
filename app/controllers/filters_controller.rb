class FiltersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_filter, only: [:update, :reset]

  def update
    FilterService.update(@filter, filter_params)

    respond_to do |format|
      if @filter.errors.empty?
        format.html { redirect_to root_path, notice: 'Filters successfully updated.' }
      else
        format.html { redirect_to root_path, alert: 'Filters have unless values.' }
      end
    end
  end

  def reset
    respond_to do |format|
      if @filter.update(Filter::DEFAULT_PARAMS)
        format.html { redirect_to root_path, notice: 'Filters successfully reset.' }
      else
        format.html { redirect_to root_path, alert: 'Filters have unless values' }
      end
    end
  end

  private

  def filter_params
    params[:filter][:data][:amount][:start] = params[:filter][:data][:amount][:start].to_f
    params.require(:filter).permit(data: {}, currency_attributes: [:name])
  end

  def set_filter
    @filter = User.find(current_user.id).filter
  end
end