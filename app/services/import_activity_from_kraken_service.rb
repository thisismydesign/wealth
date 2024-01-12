# frozen_string_literal: true

class ImportActivityFromKrakenService < ApplicationService
  attr_accessor :csv_file

  ASSET_MAPPING = {
    'ZEUR' => 'EUR',
    'XXBT' => 'BTC',
    'XETH' => 'ETH',
    'XXDG' => 'DOGE',
    'XBT.M' => 'BTC',
    'SOL03.S' => 'SOL'
  }.freeze

  def call
    CSV.foreach(csv_file.path, headers: true) do |row|
      if spend_or_receive?(row)
        import_spend_and_receive(row)
      elsif trade?(row)
        import_trade(row)
      elsif staking?(row)
        import_staking(row)
      end
    end
  end

  private

  def trades
    @trades ||= {}
  end

  def staking?(row)
    row['type'] == 'staking'
  end

  def import_staking(row)
    Income.where(
      asset: asset(row['asset']),
      date: row['time'],
      amount: row['amount'].to_d - row['fee'].to_d,
      income_type: IncomeType.staking,
      source: asset(row['asset'])
    ).first_or_create!
  end

  def trade?(row)
    row['type'] == 'trade'
  end

  def import_trade(row)
    # On trades, fees are handled in a separate row, skip those
    return if row['amount'].to_d.zero?

    id = row['refid']

    trade = trades[id]

    if trade.nil?
      trades[id] = new_from_trade(row)
    else
      add_to_portion(trade, row)
      trade.save!

      trades.delete(id)
    end
  end

  def spend_or_receive?(row)
    row['type'] == 'spend' || row['type'] == 'receive'
  end

  def import_spend_and_receive(row)
    id = row['refid']

    if row['type'] == 'spend'
      trades[id] = new_from_trade(row)
    elsif row['type'] == 'receive'
      trade = trades[id]

      Rails.logger.warn("No spend for receive: #{row}") && return if trade.nil?

      add_to_portion(trade, row)
      trade.save!

      trades.delete(id)
    end
  end

  def new_from_trade(row)
    total_cost = -row['amount'].to_d + row['fee'].to_d
    Trade.where(from_amount: total_cost, from: asset(row['asset']), date: row['time']).first_or_initialize
  end

  def add_to_portion(trade, row)
    trade.to_amount = row['amount'].to_d
    trade.to = asset(row['asset'])
  end

  def asset(asset_name)
    ticker = ASSET_MAPPING[asset_name] || asset_name

    Asset.where(
      ticker:,
      asset_source: AssetSource.kraken,
      asset_type: AssetType.crypto
    ).first_or_create!(name: ticker)
  end
end
