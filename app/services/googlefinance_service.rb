# frozen_string_literal: true

class GooglefinanceService < ApplicationService
  attr_accessor :sheet

  def call
    Faraday.get(url)
  end

  private

  def url
    "https://docs.google.com/spreadsheets/d/#{ENV.fetch('GOOGLEFINANCE_SHEET_ID')}/gviz/tq?tqx=out:csv&sheet=#{sheet}"
  end
end
