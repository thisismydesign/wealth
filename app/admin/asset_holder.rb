# frozen_string_literal: true

ActiveAdmin.register AssetHolder do
  menu parent: 'Assets'

  index do
    column :name do |resource|
      link_to(resource.name, admin_asset_holder_path(resource))
    end

    actions
  end

  filter :name

  permit_params :name
end
