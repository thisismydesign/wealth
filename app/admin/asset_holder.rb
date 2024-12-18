# frozen_string_literal: true

ActiveAdmin.register AssetHolder do
  menu priority: 32

  index do
    column :name do |resource|
      link_to(resource.name, admin_asset_holder_path(resource))
    end
    column :user if current_user.admin?

    actions
  end

  filter :name

  show do
    attributes_table do
      row :name
    end
  end

  form do |f|
    f.inputs do
      f.input :name
    end
    f.actions
  end

  controller do
    def create
      params[:asset_holder][:user_id] = current_user.id
      super
    end
  end

  permit_params :name, :user_id
end
