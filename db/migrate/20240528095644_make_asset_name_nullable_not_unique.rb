# frozen_string_literal: true

class MakeAssetNameNullableNotUnique < ActiveRecord::Migration[7.1]
  def change
    change_column_null :assets, :name, true
    remove_index :assets, :name
  end
end
