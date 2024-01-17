# frozen_string_literal: true

class ImportActivityFromIbkrService < ApplicationService
  attr_accessor :csv_file

  def call
    CSV.foreach(csv_file.path, headers: false, liberal_parsing: true) do |row|
      if trade?(row)
        import_trade(row)
      elsif funding?(row)
        import_funding(row)
      elsif dividend?(row)
        import_dividend(row)
      end
    end

    assign_trade_pairs
  end

  private

  def assign_trade_pairs
    Trade.includes(:from, :open_trade_pairs,
                   to: :asset_type).where(asset_type: { name: 'Currency' }).find_each do |close_trade|
      AssignFifoOpenTradePairsService.call(close_trade_id: close_trade.id)
    end
  end

  def trade?(row)
    row[0] == 'Trades' && row[1] == 'Data' && row[2] == 'Order'
  end

  def import_trade(row)
    from = ensure_asset(row[4])
    to = ensure_asset(row[5])

    return unless from && to

    Trade.where(row_to_trade(row, from, to)).first_or_create!
  end

  def row_to_trade(row, from, to)
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
    row[0] == 'Dividends' && row[1] == 'Data'
  end

  def import_dividend(row)
    return if row[3].blank?

    asset = ensure_asset(row[2])
    source = ensure_asset(row[4].split('(').first.strip)

    return if !asset || !source

    create_income(row, asset, source)
  end

  def create_income(row, asset, source)
    Income.where(
      asset:, date: row[3], amount: to_big_decimal(row[5]), income_type: IncomeType.dividend,
      source:, asset_holder:
    ).first_or_create!
  end

  def to_big_decimal(amount)
    amount.delete(',').to_d
  end
end
