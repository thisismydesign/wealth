# frozen_string_literal: true

ActiveAdmin.register Deposit do
  index do
    column :date
    column :amount
    column :asset

    actions
  end

  filter :amount
end
