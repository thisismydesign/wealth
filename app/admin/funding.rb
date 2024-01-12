# frozen_string_literal: true

ActiveAdmin.register Funding do
  menu priority: 5

  index do
    column :date do |income|
      income.date.strftime('%Y.%m.%d')
    end
    column :amount, class: 'secret'
    column :asset
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
