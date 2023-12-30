# frozen_string_literal: true

class CreateTrades < ActiveRecord::Migration[7.1]
  def change
    create_table :trades do |t|
      t.datetime :date, null: false
      t.decimal :from_amount, null: false
      t.decimal :to_amount, null: false
      t.references :from, null: false, foreign_key: { to_table: :assets }
      t.references :to, null: false, foreign_key: { to_table: :assets }

      t.timestamps
    end
  end
end
