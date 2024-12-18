# frozen_string_literal: true

ActiveAdmin.register Asset do
  menu priority: 31

  index do
    column :ticker do |resource|
      link_to(resource.ticker, admin_asset_path(resource))
    end
    column :name
    column :description
    column :asset_type
    column :user if current_user.admin?

    actions
  end

  filter :name
  filter :ticker
  filter :description

  show do
    attributes_table do
      row :name
      row :ticker
      row :description
      row :asset_type
    end
  end

  form do |f|
    f.inputs do
      f.input :ticker
      f.input :name
      f.input :description
      f.input :asset_type, include_blank: false
    end
    f.actions
  end

  controller do
    def scoped_collection
      super.includes(:asset_type)
    end

    def create
      params[:asset][:user_id] = current_user.id
      super
    end
  end

  permit_params :name, :ticker, :description, :asset_type_id, :user_id
end
