# frozen_string_literal: true

class DropTradePrices < ActiveRecord::Migration[7.1]
  def change
    # rubocop:disable Rails/ReversibleMigration
    drop_table :trade_prices
    # rubocop:enable Rails/ReversibleMigration
  end
end
