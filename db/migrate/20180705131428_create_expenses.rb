class CreateExpenses < ActiveRecord::Migration[5.2]
  def change
    create_table :expenses do |t|
      t.decimal :amount, null: false, default: 0
      t.string :name
      t.string :expense_type

      t.timestamps null: false
    end
  end
end
