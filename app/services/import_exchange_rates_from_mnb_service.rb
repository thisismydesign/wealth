# frozen_string_literal: true

class ImportExchangeRatesFromMnbService < ApplicationService
  def call
    Asset.where(asset_type: AssetType.find_by(name: 'Currency')).where.not(ticker: 'HUF').find_each do |asset|
      page = fetch_page(asset.ticker)
      table = page.css('table').first

      raise ApplicationError, 'No table found' unless table

      import(extract_rows_from(table), asset.ticker)
    end
  end

  private

  def fetch_page(ticker)
    response = Faraday.get(url(ticker))

    Nokogiri::HTML(response.body)
  end

  def extract_rows_from(table)
    table.css('th').map(&:text)
    table.css('tr').map do |row|
      row.css('td').map(&:text)
    end
  end

  def url(ticker)
    "https://www.mnb.hu/en/arfolyam-tablazat?deviza=rbCurrencySelect&devizaSelected=#{ticker}&datefrom=#{start_date}&datetill=#{end_date}"
  end

  def start_date
    "#{Rails.application.config.x.start_year}.01.01."
  end

  def end_date
    Time.zone.today.strftime('%Y.%m.%d.')
  end

  def import(rows, ticker)
    from = Asset.find_by(ticker:)
    to = Asset.find_by(ticker: 'HUF')

    rows.each do |row|
      next if row.empty?

      date = Date.parse(row[0])
      rate = row[1].to_d

      ExchangeRate.where(date:, rate:, from:, to:).first_or_create!
    end
  end
end
