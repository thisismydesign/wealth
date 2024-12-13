# frozen_string_literal: true

ActiveAdmin.register AssetHolder do
  menu priority: 32

  index do
    column :name do |resource|
      link_to(resource.name, admin_asset_holder_path(resource))
    end

    actions
  end

  filter :name

  show do
    attributes_table do
      row :name
    end
  end

  permit_params :name
end
