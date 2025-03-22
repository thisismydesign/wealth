# frozen_string_literal: true

class AddSourceToExchangeRates < ActiveRecord::Migration[8.0]
  def change
    add_column :exchange_rates, :source, :string
  end
end
