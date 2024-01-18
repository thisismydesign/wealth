# frozen_string_literal: true

class CreatePrices < ActiveRecord::Migration[7.1]
  def change
    create_table :prices do |t|
      t.references :priceable, polymorphic: true, index: true, null: false
      t.references :asset, null: false, foreign_key: true
      t.decimal :amount, null: false

      t.timestamps
    end
  end
end
