# frozen_string_literal: true

class RenameAssetSourceIdToAssetHolderIdOnFundings < ActiveRecord::Migration[7.1]
  def change
    rename_column :fundings, :asset_source_id, :asset_holder_id
  end
end
