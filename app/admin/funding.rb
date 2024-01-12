# frozen_string_literal: true

ActiveAdmin.register Funding do
  menu priority: 5

  index do
    column :date do |income|
      income.date.strftime('%Y.%m.%d')
    end
    column :amount
    column :asset

    actions
  end

  config.sort_order = 'date_desc'

  controller do
    def scoped_collection
      super.includes(:asset)
    end
  end

  filter :amount

  permit_params :date, :amount, :asset_id

  form do |f|
    inputs do
      f.input :asset
      f.input :amount
      f.input :date, as: :date_time_picker
    end

    actions
  end
end
