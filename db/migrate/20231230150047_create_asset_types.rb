# frozen_string_literal: true

class CreateAssetTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :asset_types do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
