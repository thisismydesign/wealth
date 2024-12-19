# frozen_string_literal: true

class ImportJob < ApplicationJob
  def perform
    ImportExchangeRatesFromMnbService.call
    # ImportRatesFromGooglefinanceService.call
  end
end
