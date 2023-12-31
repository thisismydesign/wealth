# frozen_string_literal: true

class ImportActivityFromIbkrService < ApplicationService
  attr_accessor :csv_file

  def call
    CSV.foreach(csv_file.path, headers: false, liberal_parsing: true) do |row|
      if trade?(row)
        import_trade(row)
      elsif deposit?(row)
        import_deposit(row)
      end
    end
  end

  private

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
    to_amount = row[7].to_d
    from_amount = row[12].to_d

    if to_amount.positive?
      { from:, to:, date: row[6], to_amount:, from_amount: }
    else
      { from: to, to: from, date: row[6], to_amount: from_amount.abs, from_amount: to_amount.abs }
    end
  end

  def deposit?(row)
    row[0] == 'Deposits & Withdrawals' && row[1] == 'Data'
  end

  def import_deposit(row)
    asset = ensure_asset(row[2])

    return unless asset

    Deposit.where(
      asset:,
      date: row[3],
      amount: row[5]
    ).first_or_create!
  end

  def ensure_asset(ticker)
    asset = Asset.find_by(ticker:)
    unless asset
      Rails.logger.warn("Asset not found: #{ticker}")
      return false
    end

    asset
  end
end
