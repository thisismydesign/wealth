# frozen_string_literal: true

class ImportActivityFromIbkrService < ApplicationService
  attr_accessor :csv_file

  def call
    CSV.foreach(csv_file.path, headers: false, liberal_parsing: true) do |row|
      if trade?(row)
        from = Asset.find_by(ticker: row[4])
        to = Asset.find_by(ticker: row[5])

        Rails.logger.warn("Asset not found: #{row[4]}") unless from
        Rails.logger.warn("Asset not found: #{row[5]}") unless to

        import_trade(row, from, to) if from && to
      end
    end
  end

  private

  def trade?(row)
    row[0] == 'Trades' && row[1] == 'Data' && row[2] == 'Order'
  end

  def import_trade(row, _from, _to)
    Trade.where(
      from: Asset.find_by(ticker: row[4]),
      to: Asset.find_by(ticker: row[5]),
      date: row[6],
      to_amount: row[7],
      from_amount: row[12]
    ).first_or_create!
  end
end
