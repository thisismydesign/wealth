# frozen_string_literal: true

ActiveAdmin.register Asset do
  index do
    column :ticker do |resource|
      link_to(resource.ticker, admin_asset_path(resource))
    end
    column :name

    actions
  end

  filter :name
  filter :ticker
  filter :description
end