# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class ImportActivityFromIbkrService < ApplicationService
  attr_accessor :csv_file

  # rubocop:disable Metrics/MethodLength
  def call
    CSV.foreach(csv_file.path, headers: false, liberal_parsing: true) do |row|
      if currency_trade?(row)
        import_currency_trade(row)
      elsif stock_trade?(row)
        import_stock_trade(row)
      elsif funding?(row)
        import_funding(row)
      elsif dividend?(row)
        import_dividend(row)
      elsif interest?(row)
        import_interest(row)
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  private

  def currency_trade?(row)
    row[0] == 'Trades' && row[1] == 'Data' && row[2] == 'Order' && row[3] == 'Forex'
  end

  def import_currency_trade(row)
    to_ticker, from_ticker = row[5].split('.')
    from = ensure_asset(from_ticker)
    to = ensure_asset(to_ticker)

    return unless from && to

    Trade.where(row_to_currency_trade(row, from, to)).first_or_create!
  end

  def row_to_currency_trade(row, from, to)
    to_amount = to_big_decimal(row[7])
    from_amount = to_big_decimal(row[10])

    if to_amount.positive?
      # Buy
      { from:, to:, date: row[6], to_amount:, from_amount: from_amount.abs, asset_holder: }
    else
      # Sell
      { from: to, to: from, date: row[6], to_amount: from_amount, from_amount: to_amount.abs, asset_holder: }
    end
  end

  def stock_trade?(row)
    row[0] == 'Trades' && row[1] == 'Data' && row[2] == 'Order' && row[3] == 'Stocks'
  end

  def import_stock_trade(row)
    from = ensure_asset(row[4])
    to = ensure_asset(row[5])

    return unless from && to

    Trade.where(row_to_stack_trade(row, from, to)).first_or_create!
  end

  def row_to_stack_trade(row, from, to)
    to_amount = to_big_decimal(row[7])
    from_amount = to_big_decimal(row[10]) + to_big_decimal(row[11])

    if to_amount.positive?
      # Buy
      { from:, to:, date: row[6], to_amount:, from_amount: from_amount.abs, asset_holder: }
    else
      # Sell
      { from: to, to: from, date: row[6], to_amount: from_amount, from_amount: to_amount.abs, asset_holder: }
    end
  end

  def funding?(row)
    row[0] == 'Deposits & Withdrawals' && row[1] == 'Data'
  end

  def import_funding(row)
    asset = ensure_asset(row[2])

    return unless asset

    Funding.where(
      asset:,
      asset_holder:,
      date: row[3],
      amount: to_big_decimal(row[5])
    ).first_or_create!
  end

  def asset_holder
    @asset_holder ||= AssetHolder.ibkr
  end

  def ensure_asset(ticker)
    asset = Asset.find_by(ticker:)
    unless asset
      Rails.logger.warn("Asset not found: #{ticker}")
      return false
    end

    asset
  end

  def dividend?(row)
    row[0] == 'Dividends' && row[1] == 'Data' && row[3].present?
  end

  def import_dividend(row)
    asset = ensure_asset(row[2])
    source = ensure_asset(row[4].split('(').first.strip)

    return if !asset || !source

    create_income(row, asset, source, IncomeType.dividend)
  end

  def interest?(row)
    row[0] == 'Interest' && row[1] == 'Data' && row[3].present?
  end

  def import_interest(row)
    asset = ensure_asset(row[2])
    source = nil

    source = ensure_asset(row[2]) if row[4].include?('Credit Interest')

    return unless asset

    create_income(row, asset, source, IncomeType.interest)
  end

  def create_income(row, asset, source, type)
    Income.where(
      asset:, date: row[3], amount: to_big_decimal(row[5]), income_type: type,
      source:, asset_holder:
    ).first_or_create!
  end

  def to_big_decimal(amount)
    amount.delete(',').to_d
  end
end
# rubocop:enable Metrics/ClassLength
