# frozen_string_literal: true

ActiveAdmin.register AssetSource do
  index do
    column :name do |resource|
      link_to(resource.name, admin_asset_source_path(resource))
    end

    actions
  end

  filter :name
end
