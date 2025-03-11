# frozen_string_literal: true

class ImportsController < ApplicationController
  # def activity_from_ibkr
  #   ImportActivityFromIbkrService.call(csv_file: params[:csv_file], user: current_user)

  #   redirect_back(fallback_location: root_path)
  # end

  def activity_from_kraken
    ImportActivityFromKrakenService.call(csv_file: params[:csv_file], user: current_user)

    redirect_back(fallback_location: root_path)
  end

  def activity_from_cointracking
    Import::ActivityFromCointracking.call(csv_file: params[:csv_file], user: current_user)

    redirect_back(fallback_location: root_path)
  end

  # def activity_from_wise
  #   ImportActivityFromWiseService.call(csv_file: params[:csv_file], user: current_user)

  #   redirect_back(fallback_location: root_path)
  # end
end
