# frozen_string_literal: true

class RemoveAssetSourceFromAssets < ActiveRecord::Migration[7.1]
  def change
    remove_reference :assets, :asset_source, index: true, null: false, foreign_key: true
  end
end
