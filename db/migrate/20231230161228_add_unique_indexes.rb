# frozen_string_literal: true

class AddUniqueIndexes < ActiveRecord::Migration[7.1]
  def change
    add_index :asset_sources, :name, unique: true
    add_index :asset_types, :name, unique: true
    add_index :assets, %i[name asset_type_id asset_source_id], unique: true,
                                                               name: 'index_assets_on_name_and_type_and_source'
  end
end
