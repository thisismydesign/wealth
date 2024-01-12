# frozen_string_literal: true

class RenameDepositToFunding < ActiveRecord::Migration[7.1]
  def change
    rename_table :deposits, :fundings
  end
end
