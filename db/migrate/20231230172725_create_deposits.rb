# frozen_string_literal: true

class CreateDeposits < ActiveRecord::Migration[7.1]
  def change
    create_table :deposits do |t|
      t.datetime :date, null: false
      t.decimal :amount, null: false
      t.references :asset, null: false, foreign_key: true

      t.timestamps
    end
  end
end
