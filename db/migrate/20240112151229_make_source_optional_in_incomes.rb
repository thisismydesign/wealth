# frozen_string_literal: true

class MakeSourceOptionalInIncomes < ActiveRecord::Migration[7.1]
  def change
    change_column_null :incomes, :source_id, true
  end
end
