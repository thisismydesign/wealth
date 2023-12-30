# frozen_string_literal: true

ActiveAdmin.register Trade do
  index do
    column :ticker do |resource|
      link_to(
        resource.humanized, admin_trade_path(resource)
      )
    end

    column :date

    actions
  end

  filter :date
  filter :from_amount
  filter :to_amount
end
