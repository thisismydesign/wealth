# frozen_string_literal: true

ActiveAdmin.register Asset do
  index do
    column :ticker do |resource|
      link_to(resource.ticker, admin_asset_path(resource))
    end
    column :name
    column :asset_type
    column :asset_source

    actions
  end

  controller do
    def scoped_collection
      super.includes(:asset_type, :asset_source)
    end
  end

  filter :name
  filter :ticker
  filter :description
end
