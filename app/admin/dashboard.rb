# frozen_string_literal: true

ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  action_item :imports_exchange_rates_from_mnb, only: :index do
    link_to 'Import exchange rates from MNB', imports_exchange_rates_from_mnb_path
  end

  content title: proc { I18n.t('active_admin.dashboard') } do
    columns do
      column do
        years = [nil] + (Rails.application.config.x.start_year..Time.zone.today.year).to_a.reverse

        years.each do |year|
          asset_balances = TotalBalancesService.call(year:)
          pie_chart_data = asset_balances.to_h { |asset_balance| [asset_balance[:name], asset_balance[:value]] }

          render 'admin/shared/stats_panel', asset_balances:, pie_chart_data:, year:
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
