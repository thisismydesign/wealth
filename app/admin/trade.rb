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
    column :type do |resource|
      status_tag(resource.type)
    end
    column :closed

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

  show do
    attributes_table do
      row :name, &:humanized
      row :date
      row :from_amount
      row :from
      row :to_amount
      row :to
      row 'Open trades' do |resource|
        resource.open_trade_pairs.map do |open_trade_pair|
          link_to(
            open_trade_pair.open_trade.humanized, admin_trade_path(open_trade_pair.open_trade)
          )
        end
      end
      row 'Close trades' do |resource|
        resource.close_trade_pairs.map do |close_trade_pairs|
          link_to(
            close_trade_pairs.close_trade.humanized, admin_trade_path(close_trade_pairs.close_trade)
          )
        end
      end
    end
  end

  form do |f|
    inputs do
      f.input :from
      f.input :to
      f.input :from_amount
      f.input :to_amount
      f.input :date, as: :date_time_picker
    end

    actions
  end
end
