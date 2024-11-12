# frozen_string_literal: true

module Ibkr
  class TickerMapperService < ApplicationService
    attr_accessor :csv_file

    EXCHANGE_MAPPING = {
      'LSEETF' => 'LON',
      'AEB' => 'AMS',
      'IBIS2' => 'FRA'
    }.freeze

    def call
      tickers = {}

      section_data = Ibkr::CsvSectionParser.call(csv_file:, section: 'Financial Instrument Information')

      section_data.each do |row|
        if row['Asset Category'] == 'Stocks'
          exchange = EXCHANGE_MAPPING[row['Listing Exch']] || row['Listing Exch']
          tickers[row['Symbol']] = "#{exchange}:#{row['Symbol']}"
        end
      end

      tickers
    end
  end
end
