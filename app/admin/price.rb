# frozen_string_literal: true

ActiveAdmin.register Price do
  menu label: '[Admin] Prices', priority: 91

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
