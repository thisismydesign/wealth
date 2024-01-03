# frozen_string_literal: true

class CreateIncomeTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :income_types do |t|
      t.string :name

      t.timestamps
    end

    add_index :income_types, :name, unique: true
  end
end
