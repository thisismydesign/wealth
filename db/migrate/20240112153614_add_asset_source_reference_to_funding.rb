# frozen_string_literal: true

class AddAssetSourceReferenceToFunding < ActiveRecord::Migration[7.1]
  def change
    # rubocop:disable Rails/NotNullColumn
    add_reference :fundings, :asset_source, null: false, foreign_key: true
    # rubocop:enable Rails/NotNullColumn
  end
end
