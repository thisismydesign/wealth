# frozen_string_literal: true

class MakeAssetTickerNotNull < ActiveRecord::Migration[7.1]
  def change
    change_column_null :assets, :ticker, false
  end
end
