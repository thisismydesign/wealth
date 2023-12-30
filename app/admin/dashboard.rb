# frozen_string_literal: true

ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  action_item :imports_exchange_rates_from_mnb, only: :index do
    link_to 'Import exchange rates from MNB', imports_exchange_rates_from_mnb_path
  end

  content title: proc { I18n.t('active_admin.dashboard') } do
    columns do
      column do
        panel 'Actions' do
          panel 'Import activity from IBKR' do
            render 'admin/shared/csv_import_form'
          end
        end

        panel 'Current balance' do
          asset_balances = TotalBalancesService.call

          table_for asset_balances do
            column :name do |asset_balance|
              link_to asset_balance[:asset].name, admin_asset_path(asset_balance[:asset])
            end
            column :ticker do |asset_balance|
              asset_balance[:asset].ticker
            end
            column :current_balance do |asset_balance|
              asset_balance[:balance]
            end
          end
        end

        panel 'Balance 2023' do
          asset_balances = TotalBalancesService.call(year: 2023)

          table_for asset_balances do
            column :name do |asset_balance|
              link_to asset_balance[:asset].name, admin_asset_path(asset_balance[:asset])
            end
            column :ticker do |asset_balance|
              asset_balance[:asset].ticker
            end
            column :current_balance do |asset_balance|
              asset_balance[:balance]
            end
          end
        end

        panel 'Balance 2022' do
          asset_balances = TotalBalancesService.call(year: 2022)

          table_for asset_balances do
            column :name do |asset_balance|
              link_to asset_balance[:asset].name, admin_asset_path(asset_balance[:asset])
            end
            column :ticker do |asset_balance|
              asset_balance[:asset].ticker
            end
            column :current_balance do |asset_balance|
              asset_balance[:balance]
            end
          end
        end
      end
    end
  end
end
