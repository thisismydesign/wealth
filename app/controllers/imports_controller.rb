# frozen_string_literal: true

class ImportsController < ApplicationController
  def exchange_rates_from_mnb
    ImportExchangeRatesFromMnbService.call

    redirect_back(fallback_location: root_path)
  end

  def rates_from_googlefinance
    ImportRatesFromGooglefinanceService.call

    redirect_back(fallback_location: root_path)
  end

  def activity_from_ibkr
    ImportActivityFromIbkrService.call(csv_file: params[:csv_file])

    redirect_back(fallback_location: root_path)
  end

  def activity_from_kraken
    ImportActivityFromKrakenService.call(csv_file: params[:csv_file])

    redirect_back(fallback_location: root_path)
  end
end
