# frozen_string_literal: true

class FundingService < ApplicationService
  attr_accessor :asset, :year, :asset_holder, :user

  def call
    scope = Funding.where(asset:, user:)
    scope = scope.where('extract(year from date) = ?', year) if year.present?
    scope = scope.where(asset_holder:) if asset_holder.present?

    scope.sum(:amount)
  end
end
