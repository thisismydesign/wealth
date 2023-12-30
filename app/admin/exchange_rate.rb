# frozen_string_literal: true

ActiveAdmin.register ExchangeRate do
  index do
    column :date
    column :rate
    column :from
    column :to

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
end
