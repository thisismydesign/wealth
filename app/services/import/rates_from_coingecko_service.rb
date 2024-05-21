# frozen_string_literal: true

module Import
  class RatesFromCoingeckoService < ApplicationService
    attr_accessor :crypto, :currency, :days

    def call
      fetch_historical_data.each do |price_data|
        date = Time.zone.at(price_data[0] / 1000).to_date
        rate = price_data[1]

        ExchangeRate.find_or_create_by!(from: crypto, to: currency, date:) do |exchange_rate|
          exchange_rate.rate = rate
        end
      end
    end

    private

    def fetch_historical_data
      url = "https://api.coingecko.com/api/v3/coins/#{crypto.name.downcase}/market_chart?vs_currency=#{currency.ticker}&days=#{days}&interval=daily"
      response = Faraday.get(url)
      raise "Failed to fetch data from Coingecko: #{response.status} - #{response.body}" unless response.status == 200

      JSON.parse(response.body)['prices']
    end
  end
end
