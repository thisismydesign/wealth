# frozen_string_literal: true

ActiveAdmin.register TradePrice do
  menu parent: 'Trades'

  index do
    selectable_column
    id_column

    column :name do |resource|
      humanized_trade resource.trade
    end

    asset_link :asset
    rouned_value :amount

    actions
  end

  filter :amount

  controller do
    def scoped_collection
      super.includes(:asset, trade: %i[from to])
    end
  end
end
