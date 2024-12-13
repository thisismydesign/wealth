# frozen_string_literal: true

ActiveAdmin.register Funding do
  menu priority: 23

  index do
    selectable_column
    id_column

    column :date do |income|
      income.date.strftime('%Y.%m.%d')
    end
    rouned_value :amount
    asset_link :asset
    column :asset_holder

    actions
  end

  config.sort_order = 'date_desc'

  controller do
    def scoped_collection
      super.includes(:asset, :asset_holder)
    end
  end

  filter :amount
  filter :asset_holder

  permit_params :date, :amount, :asset_id, :asset_holder_id

  form do |f|
    inputs do
      f.input :asset
      f.input :asset_holder
      f.input :amount
      f.input :date, as: :date_time_picker
    end

    actions
  end
end
