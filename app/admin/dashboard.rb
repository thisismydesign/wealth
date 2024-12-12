# frozen_string_literal: true

ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  action_item :imports_exchange_rates_from_mnb, only: :index do
    link_to 'Import exchange rates from MNB', imports_exchange_rates_from_mnb_path
  end

  content title: proc { I18n.t('active_admin.dashboard') } do
    asset_balances = TotalBalancesService.call(user: current_user)

    balances = asset_balances.filter { |balance| !balance[:balance].zero? }
    balances = balances.group_by { |balance| balance[:asset_holder] }

    total = asset_balances.sum { |asset_balance| asset_balance[:value] }
    real_estate_value = asset_balances.sum do |balance|
      balance[:asset].asset_type == AssetType.real_estate ? balance[:value] : 0
    end

    total_balances = [{
      name: 'Total',
      value: total
    }]

    if real_estate_value.positive?
      total_balances << {
        name: 'Total liquid',
        value: total - real_estate_value
      }

      total_balances << {
        name: 'Total real estate',
        value: real_estate_value
      }
    end

    panel 'Total Balance' do
      table_for total_balances do
        column :name
        column :value do |balance|
          optional_currency balance[:value], Asset.trade_base
        end
      end
    end

    panel 'Balance by Asset Holder' do
      balances.each_value do |balance|
        table_for balance do
          column :asset_holder
          asset_link :asset
          rouned_value :balance
          rouned_value :value
        end
      end
    end

    panel 'Balance by Asset' do
      balance_by_asset = GroupBalancesService.call(asset_balances:) do |asset_balance|
        [asset_balance[:asset], asset_balance[:asset].ticker]
      end
      balance_by_asset = balance_by_asset.filter { |balance| !balance[:balance].zero? }

      pie_chart_data = balance_by_asset.to_h { |balance| [balance[:group_by].ticker, balance[:value]] }

      table_for balance_by_asset do
        asset_link :group_by
        rouned_value :balance
        rouned_value :value
      end

      render 'admin/shared/pie_chart', data: pie_chart_data
    end

    panel 'Balance by Asset Type' do
      balance_by_asset_type = GroupBalancesService.call(asset_balances:) do |asset_balance|
        [asset_balance[:asset].asset_type, asset_balance[:asset].asset_type.name]
      end

      pie_chart_data = balance_by_asset_type.to_h { |balance| [balance[:group_by].name, balance[:value]] }

      table_for balance_by_asset_type do
        column :group_by do |balance|
          link_to(balance[:group_by].name, admin_asset_type_path(balance[:group_by]))
        end
        rouned_value :value
      end

      render 'admin/shared/pie_chart', data: pie_chart_data
    end

    panel 'Balance by Asset Holder' do
      balance_by_asset_holder = GroupBalancesService.call(asset_balances:) do |asset_balance|
        [asset_balance[:asset_holder], asset_balance[:asset_holder].name]
      end
      pie_chart_data = balance_by_asset_holder.to_h { |balance| [balance[:group_by].name, balance[:value]] }

      table_for balance_by_asset_holder do
        column :group_by do |balance|
          link_to(balance[:group_by].name, admin_asset_holder_path(balance[:group_by]))
        end
        rouned_value :value
        rouned_value :funding
      end

      render 'admin/shared/pie_chart', data: pie_chart_data
    end

    panel 'Actions' do
      panel 'Import activity from Kraken' do
        render 'admin/shared/csv_import_form', path: imports_activity_from_kraken_path
      end

      # panel 'Import activity from IBKR' do
      #   render 'admin/shared/csv_import_form', path: imports_activity_from_ibkr_path
      # end

      # panel 'Import activity from Wise' do
      #   render 'admin/shared/csv_import_form', path: imports_activity_from_wise_path
      # end
    end
  end
end
