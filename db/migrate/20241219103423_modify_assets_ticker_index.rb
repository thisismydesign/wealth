# frozen_string_literal: true

class ModifyAssetsTickerIndex < ActiveRecord::Migration[8.0]
  def change
    remove_index :assets, :ticker
    add_index :assets, %i[ticker user_id], unique: true
  end
end
