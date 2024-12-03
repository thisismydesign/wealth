# frozen_string_literal: true

class AddUserReferenceToModels < ActiveRecord::Migration[7.1]
  def change
    add_reference :fundings, :user, foreign_key: true, index: true
    add_reference :incomes, :user, foreign_key: true, index: true
    add_reference :trades, :user, foreign_key: true, index: true
  end
end
