# frozen_string_literal: true

class FundingService < ApplicationService
  attr_accessor :asset, :year, :asset_holder, :user

  def call
    scope = funding_scope.where(asset:)
    scope = scope.where("strftime('%Y', date) = ?", year.to_s) if year.present?
    scope = scope.where(asset_holder:) if asset_holder.present?

    scope.sum(:amount)
  end

  private

  def funding_scope
    FundingPolicy::Scope.new(user, Funding).resolve
  end
end
