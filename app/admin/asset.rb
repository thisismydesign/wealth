# frozen_string_literal: true

ActiveAdmin.register Asset do
  index do
    column :name do |resource|
      link_to(resource.name, admin_asset_path(resource))
    end

    actions
  end
end
