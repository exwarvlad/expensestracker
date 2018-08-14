class AddDurationToFilter < ActiveRecord::Migration[5.2]
  # daterange type not came
  def change
    add_column :filters, :duration_start, :date
    add_column :filters, :duration_end, :date
  end
end
