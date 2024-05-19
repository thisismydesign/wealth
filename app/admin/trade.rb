# frozen_string_literal: true

ActiveAdmin.register Trade do
  menu priority: 2

  config.per_page = [30, 50, 100, 1000]

  scope(:all, default: true)
  scope(:close_trades)
  scope(:open_trades)

  index do
    selectable_column
    id_column

    column :name do |resource|
      humanized_trade resource
    end

    column :date do |resource|
      resource.date.strftime('%Y.%m.%d')
    end

    rouned_value :from_amount
    asset_link :from

    rouned_value :to_amount
    asset_link :to
    column :asset_holder

    column :type do |resource|
      status_tag(resource.type)
    end
    column :open_status do |resource|
      status = resource.open_trade_status
      status_tag(status) if status.present?
    end
  end

  config.sort_order = 'date_desc'

  controller do
    def scoped_collection
      super.includes(:close_trade_pairs, :asset_holder, from: :asset_type, to: :asset_type)
    end
  end

  filter :date
  filter :from_amount
  filter :to_amount
  filter :to
  filter :from
  filter :asset_holder

  permit_params :date, :from_amount, :from_id, :to_amount, :to_id, :asset_holder_id

  show do
    attributes_table do
      row :name, &:humanized
      row :date
      row :from_amount
      row :from
      row :to_amount
      row :to
      row :open_trades do |resource|
        resource.open_trade_pairs.map do |open_trade_pair|
          link_to(
            open_trade_pair.open_trade.humanized, admin_trade_path(open_trade_pair.open_trade)
          )
        end
      end
      row :close_trades do |resource|
        resource.close_trade_pairs.map do |close_trade_pair|
          link_to(
            close_trade_pair.close_trade.humanized, admin_trade_path(close_trade_pair.close_trade)
          )
        end
      end
      row :prices do |resource|
        resource.prices.map do |price|
          link_to(
            price.humanized, admin_price_path(price)
          )
        end
      end
    end
  end

  member_action :assign_fifo_open_trade_pairs, method: :post do
    AssignFifoOpenTradePairsService.call(close_trade_id: resource.id)
    redirect_to resource_path
  end

  action_item :assign_fifo_open_trade_pairs, only: :show do
    link_to 'Assign FIFO Open Trade Pairs', assign_fifo_open_trade_pairs_admin_trade_path(resource), method: :post
  end

  form do |f|
    inputs do
      f.input :from
      f.input :to
      f.input :from_amount
      f.input :to_amount
      f.input :date, as: :date_time_picker
      f.input :asset_holder
    end

    actions
  end
end
