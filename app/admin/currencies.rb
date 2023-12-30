# frozen_string_literal: true

ActiveAdmin.register Currency do
  index do
    column :name do |resource|
      link_to(resource.name, admin_currency_path(resource))
    end

    actions
  end
end
