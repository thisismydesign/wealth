# frozen_string_literal: true

ActiveAdmin.register Trade do
  index do
    column :name do |resource|
      link_to(
        resource.humanized, admin_trade_path(resource)
      )
    end

    column :date
    column :from_amount
    column :from
    column :to_amount
    column :to

    actions
  end

  config.sort_order = 'date_desc'

  controller do
    def scoped_collection
      super.includes(:from, :to)
    end
  end

  filter :date
  filter :from_amount
  filter :to_amount

  permit_params :date, :from_amount, :from_id, :to_amount, :to_id
end
