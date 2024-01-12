# frozen_string_literal: true

class RenameAssetSourcesToAssetHolders < ActiveRecord::Migration[7.1]
  def change
    rename_table :asset_sources, :asset_holders
  end
end
