# frozen_string_literal: true

class AddUserToAssetsAndAssetHolders < ActiveRecord::Migration[8.0]
  def change
    add_reference :assets, :user, null: true, foreign_key: true
    add_reference :asset_holders, :user, null: true, foreign_key: true
  end
end
