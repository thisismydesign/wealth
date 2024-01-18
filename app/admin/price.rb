# frozen_string_literal: true

ActiveAdmin.register Price do
  menu parent: 'Trades'

  index do
    selectable_column
    id_column

    column :priceable

    asset_link :asset
    rouned_value :amount

    actions
  end

  filter :amount

  controller do
    def scoped_collection
      super.includes(:asset, :priceable)
    end
  end
end
