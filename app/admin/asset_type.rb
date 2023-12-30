# frozen_string_literal: true

ActiveAdmin.register AssetType do
  index do
    column :name do |resource|
      link_to(resource.name, admin_asset_type_path(resource))
    end

    actions
  end

  config.filters = false
end
