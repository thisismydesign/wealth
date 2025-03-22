# frozen_string_literal: true

class ExchangeRatePolicy < AdminPolicy
  def index?
    true
  end

  def show?
    super || (AssetPolicy.new(user, record.from).show? && AssetPolicy.new(user, record.to).show?)
  end

  def create?
    false
  end

  def update?
    false
  end

  class Scope < AdminPolicy::Scope
    def resolve
      if user.admin?
        scope.all
      else
        visible_assets = AssetPolicy::Scope.new(user, Asset).resolve
        scope.where(from: visible_assets, to: visible_assets)
      end
    end
  end
end
