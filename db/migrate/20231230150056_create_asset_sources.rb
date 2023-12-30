# frozen_string_literal: true

class CreateAssetSources < ActiveRecord::Migration[7.1]
  def change
    create_table :asset_sources do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
