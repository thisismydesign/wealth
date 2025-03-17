# frozen_string_literal: true

class AddTypeToTrades < ActiveRecord::Migration[8.0]
  def change
    add_column :trades, :trade_type, :integer

    add_index :trades, :trade_type
  end
end
