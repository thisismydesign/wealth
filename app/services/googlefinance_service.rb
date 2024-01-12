# frozen_string_literal: true

class GooglefinanceService < ApplicationService
  attr_accessor :sheet

  def call
    return if sheet_id.blank?

    Faraday.get(url)
  end

  private

  def url
    "https://docs.google.com/spreadsheets/d/#{sheet_id}/gviz/tq?tqx=out:csv&sheet=#{sheet}"
  end

  def sheet_id
    @sheet_id ||= ENV.fetch('GOOGLEFINANCE_SHEET_ID', nil)
  end
end
