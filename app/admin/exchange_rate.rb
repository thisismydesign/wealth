# frozen_string_literal: true

ActiveAdmin.register ExchangeRate do
  menu label: '[Admin] Exchange rates', priority: 94

  config.sort_order = 'date_desc'

  index do
    column :date do |exchange_rate|
      exchange_rate.date.strftime('%Y.%m.%d')
    end
    rouned_value :rate
    asset_link :from
    asset_link :to

    actions
  end

  filter :date

  controller do
    def scoped_collection
      super.includes(:from, :to)
    end
  end
end
