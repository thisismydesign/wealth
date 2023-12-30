# frozen_string_literal: true

ActiveAdmin.register ExchangeRate do
  index do
    column :date
    column :rate
    column :from
    column :to

    actions
  end

  filter :amount
end
