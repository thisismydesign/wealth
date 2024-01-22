# frozen_string_literal: true

class FundingService < ApplicationService
  attr_accessor :asset, :year

  def call
    scope = Funding.where(asset:)
    scope = scope.where('extract(year from date) = ?', year) if year.present?

    scope.sum(:amount)
  end
end
