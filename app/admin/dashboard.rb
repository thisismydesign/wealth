# frozen_string_literal: true

ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  action_item :imports_exchange_rates_from_mnb, only: :index do
    link_to 'Import exchange rates from MNB', imports_exchange_rates_from_mnb_path
  end

  content title: proc { I18n.t('active_admin.dashboard') } do
    columns do
      column do
        render 'admin/shared/stats_panel', year: nil

        (Rails.application.config.x.start_year..Time.zone.today.year).to_a.reverse_each do |year|
          render 'admin/shared/stats_panel', year:
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
