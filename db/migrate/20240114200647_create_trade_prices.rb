# frozen_string_literal: true

class CreateTradePrices < ActiveRecord::Migration[7.1]
  def change
    create_table :trade_prices do |t|
      t.references :asset, null: false, foreign_key: true
      t.references :trade, null: false, foreign_key: true
      t.decimal :amount, null: false

      t.timestamps
    end
  end
end
