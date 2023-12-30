# frozen_string_literal: true

class ImportsController < ApplicationController
  def exchange_rates_from_mnb
    ImportExchangeRatesFromMnbService.call

    redirect_back(fallback_location: root_path)
  end
end
