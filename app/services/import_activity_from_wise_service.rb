# frozen_string_literal: true

require 'csv'

class ImportActivityFromWiseService < ApplicationService
  attr_accessor :csv_file, :user

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
    asset = EnsureAssetService.call(name: row['Currency'], type: AssetType.currency, user:)
    source = asset

    return unless asset

    create_income(row, asset, source, IncomeType.interest)
  end

  def create_income(row, asset, source, type)
    Income.where(
      asset:, date: row['Date'], amount: row['Amount'].to_d, income_type: type,
      source:, asset_holder:, user:
    ).first_or_create!
  end

  def asset_holder
    @asset_holder ||= AssetHolder.wise
  end
end
