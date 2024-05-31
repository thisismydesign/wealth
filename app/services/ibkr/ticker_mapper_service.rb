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

      CSV.foreach(csv_file.path, headers: false, liberal_parsing: true) do |row|
        if row[0] == 'Financial Instrument Information' && row[1] == 'Data' && row[2] == 'Stocks'
          tickers[row[3]] = "#{EXCHANGE_MAPPING[row[7]]}:#{row[3]}"
        end
      end

      tickers
    end
  end
end
