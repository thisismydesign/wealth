# frozen_string_literal: true

class AddAssetTypeAndSourceToAssets < ActiveRecord::Migration[7.1]
  def change
    # rubocop:disable Rails/NotNullColumn
    add_reference :assets, :asset_type, null: false, foreign_key: true
    add_reference :assets, :asset_source, null: false, foreign_key: true
    # rubocop:enable Rails/NotNullColumn

    remove_column :assets, :is_currency, :boolean if column_exists?(:assets, :is_currency)
  end
end
