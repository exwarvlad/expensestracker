class CreateFilters < ActiveRecord::Migration[5.2]
  def change
    create_table :filters do |t|
      t.references :user, index: true, foreign_key: true
      t.json :data, null: false, default: {}

      t.timestamps
    end
  end
end
