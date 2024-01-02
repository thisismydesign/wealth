# frozen_string_literal: true

class CreateTradePairs < ActiveRecord::Migration[7.1]
  def change
    create_table :trade_pairs do |t|
      t.references :open_trade, null: false, foreign_key: { to_table: :trades }
      t.references :close_trade, null: false, foreign_key: { to_table: :trades }
      t.decimal :amount, null: false

      t.timestamps
    end

    add_index :trade_pairs, %i[open_trade_id close_trade_id], unique: true,
                                                              name: 'index_trade_pairs_on_open_trade_close_trade'
  end
end
