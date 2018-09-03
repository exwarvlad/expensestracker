class CreateExpensesSenders < ActiveRecord::Migration[5.2]
  def change
    create_table :expenses_senders do |t|
      t.string :email
      t.references :user, index: true

      t.timestamps
    end
  end
end
