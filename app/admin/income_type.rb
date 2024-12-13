# frozen_string_literal: true

ActiveAdmin.register IncomeType do
  menu label: '[Admin] Income types', priority: 95

  index do
    column :name do |resource|
      link_to(resource.name, admin_income_type_path(resource))
    end

    actions
  end

  filter :name

  permit_params :name
end
