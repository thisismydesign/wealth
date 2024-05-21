# frozen_string_literal: true

# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/MethodLength
module Admin
  module CustomColumns
    def rouned_value(name)
      column name, class: 'secret' do |resource|
        value = resource.is_a?(Hash) ? resource[name] : resource.send(name)
        number_with_delimiter(RoundService.call(decimal: value))
      end
    end

    def asset_link(name)
      column name do |resource|
        asset = resource.is_a?(Hash) ? resource[name] : resource.send(name)
        link_to(asset.ticker, admin_asset_path(asset)) if asset.present?
      end
    end

    def humanized_trade(trade = nil)
      if trade.id.present?
        link_to(
          trade.humanized, admin_trade_path(trade), class: 'secret'
        )
      else
        span trade.humanized, class: 'secret'
      end
    end

    def optional_currency(value, asset)
      if value.present?
        span "#{formatted_currency(value)} #{asset.ticker}", class: 'secret'
      else
        'N/A'
      end
    end

    def open_positions_table(label, open_positions, tax_base)
      panel label do
        table_for open_positions do
          column :name do |trade|
            humanized_trade trade
          end

          rouned_value :from_amount
          asset_link :from

          rouned_value :to_amount
          asset_link :to

          column :total_open_price do |trade|
            optional_currency trade.tax_base_price&.amount, tax_base
          end
        end
      end
    end

    def closed_positions_table(close_trades, year, tax_base)
      panel "Positions closed in #{year}" do
        table_for close_trades do
          column :name do |trade|
            humanized_trade trade
          end

          column :date do |trade|
            trade.date.strftime('%Y.%m.%d')
          end

          rouned_value :from_amount
          asset_link :from

          rouned_value :to_amount
          asset_link :to

          column :open_price do |trade|
            optional_currency CalculateOpenPriceService.call(close_trade: trade), tax_base
          end

          column :close_price do |trade|
            optional_currency trade.tax_base_price&.amount, tax_base
          end

          column :profit do |trade|
            open_price = CalculateOpenPriceService.call(close_trade: trade)
            profit = CalculateProfitService.call(close_trade: trade)
            percentage_profit = profit / open_price * 100

            optional_currency profit, tax_base
            span " (#{percentage_profit.round(2)}%)"
          end
        end
      end
    end
  end
end
# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/AbcSize

# Including here on top-level, in other places it fails
# rubocop:disable Style/MixinUsage
include Admin::CustomColumns
# rubocop:enable Style/MixinUsage
