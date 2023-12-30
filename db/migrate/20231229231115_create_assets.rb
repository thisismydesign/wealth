# frozen_string_literal: true

class CreateAssets < ActiveRecord::Migration[7.1]
  def change
    create_table :assets do |t|
      t.string :name, null: false
      t.string :ticker
      t.string :description
      t.boolean :is_currency, null: false, default: false

      t.timestamps
    end
  end
end
