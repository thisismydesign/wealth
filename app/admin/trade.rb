# frozen_string_literal: true

ActiveAdmin.register Trade do
  menu priority: 21

  config.per_page = [30, 50, 100, 1000]

  index do
    selectable_column
    id_column

    column :name do |resource|
      humanized_trade resource
    end

    column :date do |resource|
      resource.date.strftime('%Y.%m.%d')
    end

    column :asset_holder

    column :trade_type do |resource|
      status_tag(resource.trade_type, class: status_class(resource))
    end

    column :user if controller.current_user.admin?

    # column :open_status do |resource|
    #   status = resource.open_trade_status
    #   status_tag(status) if status.present?
    # end
  end

  config.sort_order = 'date_desc'

  controller do
    def scoped_collection
      super.includes(:close_trade_pairs, :asset_holder, from: :asset_type, to: :asset_type)
    end

    helper_method :status_class

    def status_class(resource)
      if resource.trade_type_open?
        'bg-green-500 dark:bg-green-900'
      elsif resource.trade_type_close?
        'bg-sky-500 dark:bg-sky-900'
      else
        'bg-gray-500 dark:bg-gray-900'
      end
    end
  end

  filter :year, as: :select, collection: lambda {
    first_year = Trade.order(:date).first&.date&.year || Time.zone.today.year
    (first_year..Time.zone.today.year).map do |year|
      [year, year]
    end
  }
  filter :date
  filter :from_amount
  filter :to_amount
  filter :to, collection: -> { AssetPolicy::Scope.new(controller.current_user, Asset).resolve }
  filter :from, collection: -> { AssetPolicy::Scope.new(controller.current_user, Asset).resolve }
  filter :asset_holder, collection: -> { AssetHolderPolicy::Scope.new(controller.current_user, AssetHolder).resolve }
  filter :trade_type, as: :select, collection: lambda {
    Trade.trade_types.map { |k, v| [k.humanize, v] }
  }
  filter :user,
         collection: -> { UserPolicy::Scope.new(controller.current_user, User).resolve.map { |u| [u.email, u.id] } },
         if: proc { controller.current_user.admin? }

  permit_params :date, :from_amount, :from_id, :to_amount, :to_id, :asset_holder_id

  show do
    attributes_table do
      row :name, &:humanized
      row :date
      row :from_amount
      row :from
      row :to_amount
      row :to
      row :trade_type do |resource|
        status_tag(resource.trade_type, class: status_class(resource))
      end
      row :open_trades do |resource|
        resource.open_trade_pairs.map do |open_trade_pair|
          link_to(
            open_trade_pair.open_trade.humanized, admin_trade_path(open_trade_pair.open_trade)
          )
        end
      end
      row :close_trades do |resource|
        resource.close_trade_pairs.map do |close_trade_pair|
          link_to(
            close_trade_pair.close_trade.humanized, admin_trade_path(close_trade_pair.close_trade)
          )
        end
      end
      row :prices do |resource|
        resource.prices.map do |price|
          link_to(
            price.humanized, admin_price_path(price)
          )
        end
      end
    end
  end

  # member_action :assign_fifo_open_trade_pairs, method: :post do
  #   AssignFifoOpenTradePairsService.call(close_trade_id: resource.id)
  #   redirect_to resource_path
  # end

  # action_item :assign_fifo_open_trade_pairs, only: :show do
  #   link_to 'Assign FIFO Open Trade Pairs', assign_fifo_open_trade_pairs_admin_trade_path(resource), method: :post
  # end

  form do |f|
    inputs do
      f.input :from, collection: AssetPolicy::Scope.new(controller.current_user, Asset).resolve
      f.input :to, collection: AssetPolicy::Scope.new(controller.current_user, Asset).resolve
      f.input :from_amount
      f.input :to_amount
      f.input :date, as: :datetime_picker
      f.input :asset_holder, collection: AssetHolderPolicy::Scope.new(controller.current_user, AssetHolder).resolve
    end

    actions
  end
end
