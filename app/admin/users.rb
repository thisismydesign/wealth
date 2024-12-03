# frozen_string_literal: true

ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation

  filter :email

  index do
    column :email do |resource|
      link_to(resource.email, admin_user_path(resource))
    end
    column :created_at do |user|
      user.created_at.strftime('%Y.%m.%d')
    end
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
