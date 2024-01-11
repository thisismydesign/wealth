# frozen_string_literal: true

class ImportActivityFromKrakenService < ApplicationService
  attr_accessor :csv_file

  ASSET_MAPPING = {
    'ZEUR' => 'EUR',
    'XXBT' => 'BTC',
    'XETH' => 'ETH',
    'XXDG' => 'DOGE'
  }.freeze

  def call
    CSV.foreach(csv_file.path, headers: true) do |row|
      if spend_or_receive?(row)
        import_spend_and_receive(row)
      elsif trade?(row)
        import_trade(row)
      end
    end

    return if trades.empty?

    Rails.logger.warn("Unmatched trades: #{trades.values}")
  end

  private

  def trades
    @trades ||= {}
  end

  def trade?(row)
    row['type'] == 'trade'
  end

  def import_trade(row)
    # On trades, fees are handled in a separate row
    return if row['fee'] != '0'

    time = row['time']

    trade = trades[time]

    if trade.nil?
      trades[time] = new_from_trade(row)
    else
      add_to_portion(trade, row)
      trade.save!

      trades.delete(time)
    end
  end

  def spend_or_receive?(row)
    row['type'] == 'spend' || row['type'] == 'receive'
  end

  def import_spend_and_receive(row)
    time = row['time']

    if row['type'] == 'spend'
      trades[time] = new_from_trade(row)
    elsif row['type'] == 'receive'
      trade = trades[time]

      Rails.logger.warn("No spend for receive: #{row}") && return if trade.nil?

      add_to_portion(trade, row)
      trade.save!

      trades.delete(time)
    end
  end

  def new_from_trade(row)
    Trade.new(from_amount: -row['amount'].to_d, from: asset(row['asset']), date: row['time'])
  end

  def add_to_portion(trade, row)
    trade.to_amount = row['amount'].to_d
    trade.to = asset(row['asset'])
  end

  def asset(asset_name)
    Asset.where(
      name: ASSET_MAPPING[asset_name] || asset_name,
      ticker: ASSET_MAPPING[asset_name] || asset_name,
      asset_source: AssetSource.kraken,
      asset_type: AssetType.crypto
    ).first_or_create!
  end
end
