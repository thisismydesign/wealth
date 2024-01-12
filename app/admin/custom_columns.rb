# frozen_string_literal: true

module Admin
  module CustomColumns
    def rouned_value(name)
      column name, class: 'secret' do |resource|
        RoundService.call(decimal: resource.send(name))
      end
    end

    def asset_link(name)
      column name do |resource|
        link_to(resource.send(name).ticker_or_name, admin_asset_path(resource.send(name)))
      end
    end

    def humanized_trade(trade = nil)
      link_to(
        trade.humanized, admin_trade_path(trade), class: 'secret'
      )
    end
  end
end

# Including here on top-level, in other places it fails
# rubocop:disable Style/MixinUsage
include Admin::CustomColumns
# rubocop:enable Style/MixinUsage
