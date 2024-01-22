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
          pie_chart_data = asset_balances.to_h { |asset_balance| [asset_balance[:asset].ticker, asset_balance[:value]] }

          columns do
            column do
              table_for asset_balances do
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
          asset_balance_by_type = asset_balances.group_by do |asset_balance|
            asset_balance[:asset].asset_type.name
          end
          asset_value_by_type = asset_balance_by_type.map do |asset_type, balances|
            {
              asset_type:,
              value: balances.sum { |balance| balance[:value] }
            }
          end

          columns do
            column do
              table_for asset_value_by_type do
                column :asset_type
                rouned_value :value
              end
            end

            column do
              render 'admin/shared/pie_chart', data: asset_value_by_type.to_h { |asset_value|
                                                       [asset_value[:asset_type], asset_value[:value]]
                                                     }
            end
          end
        end

        panel 'Funding' do
          fundings = TotalFundingsService.call

          table_for fundings do
            column :ticker do |funding|
              funding[:ticker]
            end
            rouned_value :funding
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
