# frozen_string_literal: true

ActiveAdmin.register User do
  menu label: '[Admin] Users', priority: 93

  permit_params do
    permitted = %i[email password password_confirmation]
    permitted << :role if current_user.admin?
    permitted
  end

  filter :email

  index do
    column :email do |resource|
      link_to(resource.email, admin_user_path(resource))
    end
    column :role
    column :created_at do |user|
      user.created_at.strftime('%Y.%m.%d')
    end
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :role, as: :select, collection: User.roles.keys, include_blank: false if current_user.admin?
    end
    f.actions
  end

  show do
    attributes_table do
      row :email
      row :created_at if current_user.admin?
      row :role if current_user.admin?
    end
  end

  controller do
    def update
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end
      super
    end
  end
end
