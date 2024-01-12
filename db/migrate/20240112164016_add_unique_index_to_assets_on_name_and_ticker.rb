# frozen_string_literal: true

class AddUniqueIndexToAssetsOnNameAndTicker < ActiveRecord::Migration[7.1]
  def change
    add_index :assets, :name, unique: true
    add_index :assets, :ticker, unique: true
  end
end
