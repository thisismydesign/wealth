# frozen_string_literal: true

ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  action_item :imports_exchange_rates_from_mnb, only: :index do
    link_to 'Import exchange rates from MNB', imports_exchange_rates_from_mnb_path
  end

  content title: proc { I18n.t('active_admin.dashboard') } do
    columns do
      column do
        asset_balances = TotalBalancesService.call

        panel 'Balance by Asset' do
          balance_by_asset = asset_balances.each_with_object({}) do |asset_balance, hash|
            asset = asset_balance[:asset]
            hash[asset.ticker] ||= { asset:, value: 0, balance: 0 }
            hash[asset.ticker][:value] += asset_balance[:value]
            hash[asset.ticker][:balance] += asset_balance[:balance]
          end.values

          pie_chart_data = balance_by_asset.to_h { |balance| [balance[:asset].ticker, balance[:value]] }

          columns do
            column do
              table_for balance_by_asset do
                asset_link :asset
                rouned_value :balance
                rouned_value :value
              end
            end

            column do
              render 'admin/shared/pie_chart', data: pie_chart_data
            end
          end
        end

        panel 'Balance by Asset Type' do
          balance_by_asset_type = asset_balances.each_with_object({}) do |asset_balance, hash|
            asset_type = asset_balance[:asset].asset_type
            hash[asset_type.name] ||= { asset_type:, value: 0 }
            hash[asset_type.name][:value] += asset_balance[:value]
          end.values

          pie_chart_data = balance_by_asset_type.to_h { |balance| [balance[:asset_type].name, balance[:value]] }

          columns do
            column do
              table_for balance_by_asset_type do
                column :asset_type
                rouned_value :value
              end
            end

            column do
              render 'admin/shared/pie_chart', data: pie_chart_data
            end
          end
        end

        panel 'Balance by Asset Holder' do
          balance_by_asset_holder = asset_balances.each_with_object({}) do |asset_balance, hash|
            asset_holder = asset_balance[:asset_holder]
            hash[asset_holder.name] ||= { asset_holder:, value: 0, funding: 0 }
            hash[asset_holder.name][:value] += asset_balance[:value]
            hash[asset_holder.name][:funding] += asset_balance[:funding]
          end.values

          pie_chart_data = balance_by_asset_holder.to_h { |balance| [balance[:asset_holder].name, balance[:value]] }

          columns do
            column do
              table_for balance_by_asset_holder do
                column :asset_holder
                rouned_value :value
                rouned_value :funding
              end
            end

            column do
              render 'admin/shared/pie_chart', data: pie_chart_data
            end
          end
        end

        panel 'Actions' do
          panel 'Import activity from IBKR' do
            render 'admin/shared/csv_import_form', path: imports_activity_from_ibkr_path
          end

          panel 'Import activity from Kraken' do
            render 'admin/shared/csv_import_form', path: imports_activity_from_kraken_path
          end
        end
      end
    end
  end
end
