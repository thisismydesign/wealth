# frozen_string_literal: true

require 'csv'

# rubocop:disable Metrics/ClassLength
class ImportActivityFromIbkrService < ApplicationService
  attr_accessor :csv_file, :custom_asset_holder, :user

  # rubocop:disable Metrics/MethodLength
  def call
    ticker_mapping = Ibkr::TickerMapperService.call(csv_file:)

    # Use CsvSectionParser for fundings
    import_fundings_with_section_parser

    CSV.foreach(csv_file.path, headers: false, liberal_parsing: true) do |row|
      if currency_trade?(row)
        import_currency_trade(row)
      elsif stock_trade?(row)
        import_stock_trade(row, ticker_mapping)
      elsif dividend?(row)
        import_dividend(row, ticker_mapping)
      elsif interest?(row)
        import_interest(row)
      elsif fee?(row)
        import_fee(row)
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  private

  def import_fundings_with_section_parser
    funding_data = Ibkr::CsvSectionParser.call(csv_file:, section: 'Deposits & Withdrawals')

    funding_data.each do |row|
      import_funding_from_section_data(row)
    end
  end

  def import_funding_from_section_data(row)
    asset = EnsureAssetService.call(name: row['Currency'], type: AssetType.currency, user:)

    return unless asset

    Funding.where(
      asset:,
      asset_holder:,
      date: row['Settle Date'],
      amount: to_big_decimal(row['Amount']),
      user:
    ).first_or_create!
  end

  def currency_trade?(row)
    row[0] == 'Trades' && row[1] == 'Data' && row[2] == 'Order' && row[3] == 'Forex'
  end

  def import_currency_trade(row)
    to_ticker, from_ticker = row[5].split('.')
    from = EnsureAssetService.call(name: from_ticker, type: AssetType.currency, user:)
    to = EnsureAssetService.call(name: to_ticker, type: AssetType.currency, user:)

    return unless from && to

    Trade.where(row_to_currency_trade(row, from, to)).first_or_create!
  end

  def row_to_currency_trade(row, from, to)
    to_amount = to_big_decimal(row[7]) + to_big_decimal(row[11])
    from_amount = to_big_decimal(row[10])

    if to_amount.positive?
      # Buy non-native currency
      { from:, to:, date: row[6], to_amount:, from_amount: from_amount.abs, asset_holder:, user: }
    else
      # Sell non-native currency
      { from: to, to: from, date: row[6], to_amount: from_amount, from_amount: to_amount.abs, asset_holder:, user: }
    end
  end

  def stock_trade?(row)
    row[0] == 'Trades' && row[1] == 'Data' && row[2] == 'Order' && row[3] == 'Stocks'
  end

  def import_stock_trade(row, ticker_mapping)
    from = EnsureAssetService.call(name: row[4], type: AssetType.currency, user:)
    to = EnsureAssetService.call(name: ticker_mapping[row[5]], type: AssetType.etf, user:)

    return unless from && to

    Trade.where(row_to_stock_trade(row, from, to)).first_or_create!
  end

  def row_to_stock_trade(row, from, to)
    to_amount = to_big_decimal(row[7])
    from_amount = to_big_decimal(row[10]) + to_big_decimal(row[11])

    if to_amount.positive?
      # Buy stock
      { from:, to:, date: row[6], to_amount:, from_amount: from_amount.abs, asset_holder:, user: }
    else
      # Sell stock
      { from: to, to: from, date: row[6], to_amount: from_amount, from_amount: to_amount.abs, asset_holder:, user: }
    end
  end

  # Keep the old funding method for backward compatibility or in case the section parser fails
  def funding?(row)
    row[0] == 'Deposits & Withdrawals' && row[1] == 'Data' && row[3].present?
  end

  def import_funding(row)
    asset = EnsureAssetService.call(name: row[2], type: AssetType.currency, user:)

    return unless asset

    Funding.where(
      asset:,
      asset_holder:,
      date: row[3],
      amount: to_big_decimal(row[5]),
      user:
    ).first_or_create!
  end

  def asset_holder
    @asset_holder ||= custom_asset_holder || AssetHolder.ibkr
  end

  def dividend?(row)
    row[0] == 'Dividends' && row[1] == 'Data' && row[3].present?
  end

  def import_dividend(row, ticker_mapping)
    source_ticker = ticker_mapping[row[4].split('(').first.strip]
    asset = EnsureAssetService.call(name: row[2], type: AssetType.currency, user:)
    source = EnsureAssetService.call(name: source_ticker, type: AssetType.etf, user:)

    return if !asset || !source

    create_income(row, asset, source, IncomeType.dividend)
  end

  def interest?(row)
    row[0] == 'Interest' && row[1] == 'Data' && row[3].present?
  end

  def import_interest(row)
    asset = EnsureAssetService.call(name: row[2], type: AssetType.currency, user:)
    source = row[4].include?('Credit Interest') ? asset : nil

    return unless asset

    create_income(row, asset, source, IncomeType.interest)
  end

  def create_income(row, asset, source, type)
    Income.where(
      asset:, date: row[3], amount: to_big_decimal(row[5]), income_type: type,
      source:, asset_holder:, user:
    ).first_or_create!
  end

  def fee?(row)
    row[0] == 'Fees' && row[1] == 'Data' && row[3].present?
  end

  def import_fee(row)
    asset = EnsureAssetService.call(name: row[3], type: AssetType.currency, user:)

    Trade.where({
                  from: asset, to: asset, date: row[4],
                  to_amount: 0, from_amount: to_big_decimal(row[6]).abs, asset_holder:, user:
                }).first_or_create!
  end

  def to_big_decimal(amount)
    amount.delete(',').to_d
  end
end
# rubocop:enable Metrics/ClassLength
