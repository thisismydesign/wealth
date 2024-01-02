# frozen_string_literal: true

ActiveAdmin.register TradePair do
  index do
    selectable_column

    column :id do |resource|
      link_to resource.id, admin_trade_pair_path(resource)
    end
    column :open_trade do |resource|
      link_to(
        resource.open_trade.humanized, admin_trade_path(resource.open_trade)
      )
    end
    column :close_trade do |resource|
      link_to(
        resource.close_trade.humanized, admin_trade_path(resource.close_trade)
      )
    end
    column :amount

    actions
  end

  controller do
    def scoped_collection
      super.includes(open_trade: %i[from to], close_trade: %i[from to])
    end
  end

  config.per_page = 100

  filter :amount
end
