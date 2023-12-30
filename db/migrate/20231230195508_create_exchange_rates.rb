# frozen_string_literal: true

class CreateExchangeRates < ActiveRecord::Migration[7.1]
  def change
    create_table :exchange_rates do |t|
      t.references :from, null: false, foreign_key: { to_table: :assets }
      t.references :to, null: false, foreign_key: { to_table: :assets }
      t.decimal :rate, null: false
      t.date :date, null: false

      t.timestamps
    end

    add_index :exchange_rates, %i[from_id to_id date], unique: true, name: 'index_exchange_rates_on_from_to_date'
  end
end
