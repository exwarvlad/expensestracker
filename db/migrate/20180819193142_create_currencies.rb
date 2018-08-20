class CreateCurrencies < ActiveRecord::Migration[5.2]
  def change
    create_table :currencies do |t|
      t.integer :name, default: 0, null: false
      t.references :currencyable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
