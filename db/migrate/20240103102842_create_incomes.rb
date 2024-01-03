# frozen_string_literal: true

class CreateIncomes < ActiveRecord::Migration[7.1]
  def change
    create_table :incomes do |t|
      t.datetime :date, null: false
      t.references :income_type, null: false, foreign_key: true

      t.decimal :amount, null: false
      t.references :asset, null: false, foreign_key: true

      t.references :source, null: false, index: true, foreign_key: { to_table: :assets }

      t.timestamps
    end
  end
end
