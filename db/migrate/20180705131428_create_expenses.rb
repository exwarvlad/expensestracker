class CreateExpenses < ActiveRecord::Migration[5.2]
  def change
    create_table :expenses do |t|
      t.string :amount
      t.string :name
      t.string :type_amount
      t.string :expense_type

      t.timestamps null: false
    end
  end
end
