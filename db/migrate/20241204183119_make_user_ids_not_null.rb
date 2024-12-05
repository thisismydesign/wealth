# frozen_string_literal: true

class MakeUserIdsNotNull < ActiveRecord::Migration[7.1]
  def change
    change_column_null :trades, :user_id, false
    change_column_null :incomes, :user_id, false
    change_column_null :fundings, :user_id, false
  end
end
