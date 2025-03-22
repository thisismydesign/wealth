# frozen_string_literal: true

class AssetPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    true
  end

  def update?
    if record.user
      record.user == user
    else
      user.admin?
    end
  end

  def show?
    if record.user
      record.user == user || user.admin?
    else
      true
    end
  end

  class Scope < AdminPolicy::Scope
    def resolve
      if user.admin?
        super
      else
        scope.where(user_id: user.id).or(scope.where(user_id: nil))
      end
    end
  end
end
