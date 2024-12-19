# frozen_string_literal: true

ActiveAdmin.register Income do
  menu priority: 22

  index do
    selectable_column
    id_column

    column :date do |income|
      income.date.strftime('%Y.%m.%d')
    end
    column :income_type
    rouned_value :amount
    asset_link :asset
    asset_link :source
    column :asset_holder

    actions
  end

  config.sort_order = 'date_desc'

  filter :year, as: :select, collection: lambda {
    first_year = Income.order(:date).first&.date&.year || Time.zone.today.year
    (first_year..Time.zone.today.year).map do |year|
      [year, year]
    end
  }
  filter :date
  filter :amount
  filter :source, collection: -> { AssetPolicy::Scope.new(controller.current_user, Asset).resolve }
  filter :income_type
  filter :asset_holder, collection: -> { AssetHolderPolicy::Scope.new(controller.current_user, AssetHolder).resolve }

  controller do
    def scoped_collection
      super.includes(:income_type, :asset, :source, :asset_holder)
    end
  end

  permit_params :amount, :date, :income_type_id, :asset_id, :source_id, :asset_holder_id

  form do |f|
    inputs do
      f.input :income_type
      f.input :asset, collection: AssetPolicy::Scope.new(controller.current_user, Asset).resolve
      f.input :asset_holder, collection: AssetHolderPolicy::Scope.new(controller.current_user, AssetHolder).resolve
      f.input :amount
      f.input :source, collection: AssetPolicy::Scope.new(controller.current_user, Asset).resolve
      f.input :date, as: :datetime_picker
    end

    actions
  end

  show do
    attributes_table do
      row :date
      row :income_type
      row :amount
      row :asset
      row :source
      row :created_at
      row :updated_at
      row :asset_holder
      row :prices do |resource|
        resource.prices.map do |price|
          link_to(
            price.humanized, admin_price_path(price)
          )
        end
      end
    end
  end
end
