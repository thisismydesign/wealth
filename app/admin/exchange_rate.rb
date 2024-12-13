# frozen_string_literal: true

ActiveAdmin.register ExchangeRate do
  menu label: '[Admin] Exchange rates', priority: 94

  index do
    column :date do |exchange_rate|
      exchange_rate.date.strftime('%Y.%m.%d')
    end
    rouned_value :rate
    asset_link :from
    asset_link :to

    actions
  end

  config.sort_order = 'date_desc'

  filter :amount

  controller do
    def scoped_collection
      super.includes(:from, :to)
    end
  end

  action_item :imports_exchange_rates_from_mnb, only: :index do
    link_to 'Import exchange rates from MNB', imports_exchange_rates_from_mnb_path
  end

  action_item :imports_rates_from_googlefinance, only: :index do
    link_to 'Import rates from Googlefinance', imports_rates_from_googlefinance_path
  end

  permit_params :date, :rate, :from_id, :to_id
end
