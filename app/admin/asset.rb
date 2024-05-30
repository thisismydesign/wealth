# frozen_string_literal: true

ActiveAdmin.register Asset do
  index do
    column :ticker do |resource|
      link_to(resource.ticker, admin_asset_path(resource))
    end
    column :name
    column :description
    column :asset_type

    actions
  end

  controller do
    def scoped_collection
      super.includes(:asset_type)
    end
  end

  filter :name
  filter :ticker
  filter :description

  permit_params :name, :ticker, :description, :asset_type_id
end
