# frozen_string_literal: true

ActiveAdmin.register Deposit do
  index do
    column :date
    column :amount
    column :asset

    actions
  end

  controller do
    def scoped_collection
      super.includes(:asset)
    end
  end

  filter :amount
end
