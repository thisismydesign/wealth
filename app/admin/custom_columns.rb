# frozen_string_literal: true

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
        link_to(asset.ticker_or_name, admin_asset_path(asset))
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
  end
end

# Including here on top-level, in other places it fails
# rubocop:disable Style/MixinUsage
include Admin::CustomColumns
# rubocop:enable Style/MixinUsage
