class AddUserToExpense < ActiveRecord::Migration[5.2]
  def change
    add_reference :expenses, :user, index: true, foreign_key: true
  end
end
