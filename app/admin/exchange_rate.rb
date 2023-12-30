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

  collection_action :import_from_mnb, method: :get do
    ImportExchangeRatesFromMnbService.call

    redirect_to collection_path
  end

  action_item :import_from_mnb, only: :index do
    link_to 'Import from MNB', action: :import_from_mnb
  end
end
