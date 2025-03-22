# frozen_string_literal: true

class ImportJob < ApplicationJob
  def perform
    Import::ExchangeRatesFromMnbService.call
    # ImportRatesFromGooglefinanceService.call
  end
end
