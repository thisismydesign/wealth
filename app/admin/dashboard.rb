# frozen_string_literal: true

ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  action_item :imports_exchange_rates_from_mnb, only: :index do
    link_to 'Import exchange rates from MNB', imports_exchange_rates_from_mnb_path
  end

  content title: proc { I18n.t('active_admin.dashboard') } do
    columns do
      column do
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

        (Rails.application.config.x.start_year..Time.zone.today.year).to_a.reverse_each do |year|
          panel "Balance #{year}" do
            panel 'Year-end balance' do
              asset_balances = TotalBalancesService.call(year:)

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

            panel 'Funding' do
              fundings = TotalDepositsService.call(year:)

              table_for fundings do
                column :ticker do |funding|
                  funding[:ticker]
                end
                column :funding do |funding|
                  funding[:funding]
                end
              end
            end
          end
        end

        panel 'Actions' do
          panel 'Import activity from IBKR' do
            render 'admin/shared/csv_import_form'
          end
        end
      end
    end
  end
end
