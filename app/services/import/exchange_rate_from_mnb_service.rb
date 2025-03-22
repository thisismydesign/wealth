# frozen_string_literal: true

module Import
  class ExchangeRateFromMnbService < ApplicationService
    attr_accessor :asset

    def call
      page = fetch_page
      table = page.css('table').first

      raise ApplicationError, 'No table found' unless table

      import(extract_rows_from(table))
    end

    private

    def fetch_page
      response = Faraday.get(url)

      Nokogiri::HTML(response.body)
    end

    def extract_rows_from(table)
      table.css('th').map(&:text)
      table.css('tr').map do |row|
        row.css('td').map(&:text)
      end
    end

    def url
      @url ||= "https://www.mnb.hu/en/arfolyam-tablazat?deviza=rbCurrencySelect&devizaSelected=#{asset.ticker}&datefrom=#{start_date}&datetill=#{end_date}"
    end

    def start_date
      "#{Rails.application.config.x.start_year}.01.01."
    end

    def end_date
      Time.zone.today.strftime('%Y.%m.%d.')
    end

    def import(rows)
      to = EnsureAssetService.call(name: 'HUF', type: AssetType.currency)

      rows.each do |row|
        next if row.empty?

        date = Date.parse(row[0])
        rate = row[1].to_d

        ExchangeRate.find_or_initialize_by(date:, from: asset, to:).tap do |exchange_rate|
          exchange_rate.source = url
          exchange_rate.rate = rate
        end.save!
      end
    end
  end
end
