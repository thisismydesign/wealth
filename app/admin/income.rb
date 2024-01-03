# frozen_string_literal: true

ActiveAdmin.register Income do
  filter :amount
  filter :date

  permit_params :amount, :date, :income_type_id, :asset_id, :source_id

  form do |f|
    inputs do
      f.input :income_type
      f.input :asset
      f.input :amount
      f.input :source
      f.input :date, as: :date_time_picker
    end

    actions
  end
end
