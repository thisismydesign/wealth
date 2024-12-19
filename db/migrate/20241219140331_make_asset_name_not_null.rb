# frozen_string_literal: true

class MakeAssetNameNotNull < ActiveRecord::Migration[8.0]
  def change
    change_column_null :assets, :name, false
  end
end
