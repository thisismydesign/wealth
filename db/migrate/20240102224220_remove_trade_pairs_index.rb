# frozen_string_literal: true

class RemoveTradePairsIndex < ActiveRecord::Migration[7.1]
  def change
    remove_index :trade_pairs, %i[open_trade_id close_trade_id], name: 'index_trade_pairs_on_open_trade_close_trade'
  end
end
