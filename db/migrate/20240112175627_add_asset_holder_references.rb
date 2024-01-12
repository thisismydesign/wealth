# frozen_string_literal: true

class AddAssetHolderReferences < ActiveRecord::Migration[7.1]
  def change
    # rubocop:disable Rails/NotNullColumn
    add_reference :trades, :asset_holder, null: false, foreign_key: true, index: true
    add_reference :incomes, :asset_holder, null: false, foreign_key: true, index: true
    # rubocop:enable Rails/NotNullColumn
  end
end
