class CreateCurrencyConverts < ActiveRecord::Migration[5.2]
  def change
    create_table :currency_converts do |t|
      t.json :total_bank
      t.json :exchange_rates
      t.string :convert_currency, null: false
      t.decimal :total_amount
      t.references :user, index: true

      t.timestamps
    end
  end
end
