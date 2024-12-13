# frozen_string_literal: true

ActiveAdmin.register TradePair do
  menu label: '[Admin] Trade pairs', priority: 92

  index do
    selectable_column

    column :id do |resource|
      link_to resource.id, admin_trade_pair_path(resource)
    end

    column :open_trade do |resource|
      humanized_trade resource.open_trade
    end

    column :close_trade do |resource|
      humanized_trade resource.close_trade
    end

    rouned_value :amount

    actions
  end

  controller do
    def scoped_collection
      super.includes(open_trade: %i[from to], close_trade: %i[from to])
    end
  end

  filter :amount

  form do |f|
    inputs do
      trade_collection = Trade.all.map do |trade|
        ["##{trade.id} - #{trade.humanized}", trade.id]
      end

      f.input :open_trade, collection: trade_collection
      f.input :close_trade, collection: trade_collection

      f.input :amount
    end

    actions
  end

  permit_params :amount, :open_trade_id, :close_trade_id
end
