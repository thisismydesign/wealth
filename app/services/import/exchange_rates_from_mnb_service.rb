# frozen_string_literal: true

module Import
  class ExchangeRatesFromMnbService < ApplicationService
    def call
      %w[USD EUR].each do |ticker|
        url = url_for_ticker(ticker)
        page = fetch_page(url)
        table = page.css('table').first

        raise ApplicationError, 'No table found' unless table

        import(extract_rows_from(table), ticker, url)
      end
    end

    private

    def fetch_page(url)
      response = Faraday.get(url)

      Nokogiri::HTML(response.body)
    end

    def extract_rows_from(table)
      table.css('th').map(&:text)
      table.css('tr').map do |row|
        row.css('td').map(&:text)
      end
    end

    def url_for_ticker(ticker)
      "https://www.mnb.hu/en/arfolyam-tablazat?deviza=rbCurrencySelect&devizaSelected=#{ticker}&datefrom=#{start_date}&datetill=#{end_date}"
    end

    def start_date
      "#{Rails.application.config.x.start_year}.01.01."
    end

    def end_date
      Time.zone.today.strftime('%Y.%m.%d.')
    end

    def import(rows, ticker, url)
      from = EnsureAssetService.call(name: ticker, type: AssetType.currency)
      to = EnsureAssetService.call(name: 'HUF', type: AssetType.currency)

      rows.each do |row|
        next if row.empty?

        date = Date.parse(row[0])
        rate = row[1].to_d

        ExchangeRate.where(date:, rate:, from:, to:).first_or_create!(source: url)
      end
    end
  end
end
