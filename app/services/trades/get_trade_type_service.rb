# frozen_string_literal: true

module Trades
  class GetTradeTypeService < ApplicationService
    attr_accessor :trade

    # rubocop:disable Metrics/MethodLength
    def call
      return unless to && from

      if fiat_close?
        :fiat_close
      elsif fiat_open?
        :fiat_open
      elsif crypto_open?
        :crypto_open
      elsif crypto_close?
        :crypto_close
      else
        :inter
      end
    end
    # rubocop:enable Metrics/MethodLength

    private

    def fiat_close?
      to.currency? && !from.currency?
    end

    def fiat_open?
      from.currency? && !to.currency?
    end

    def crypto_open?
      from.stablecoin? && to.crypto?
    end

    def crypto_close?
      from.crypto? && to.stablecoin?
    end

    def to
      trade.to
    end

    def from
      trade.from
    end
  end
end
