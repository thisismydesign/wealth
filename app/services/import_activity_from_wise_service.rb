# frozen_string_literal: true

class ImportActivityFromWiseService < ApplicationService
  attr_accessor :csv_file

  def call
    CSV.foreach(csv_file.path, headers: true) do |row|
      import_interest(row) if interest?(row)
    end
  end

  private

  def interest?(row)
    row['Description'] == 'Balance cashback'
  end

  def import_interest(row)
    asset = EnsureAssetService.call(ticker: row['Currency'], asset_type: AssetType.currency)
    source = asset

    return unless asset

    create_income(row, asset, source, IncomeType.interest)
  end

  def create_income(row, asset, source, type)
    Income.where(
      asset:, date: row['Date'], amount: row['Amount'].to_d, income_type: type,
      source:, asset_holder:
    ).first_or_create!
  end

  def asset_holder
    @asset_holder ||= AssetHolder.wise
  end
end
