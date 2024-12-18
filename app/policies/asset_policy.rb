# frozen_string_literal: true

class AssetPolicy < PublicPolicy
  def create?
    true
  end

  def update?
    record.user == user
  end

  class Scope < AdminPolicy::Scope
    def resolve
      scope.where(user_id: user.id).or(scope.where(user_id: nil))
    end
  end
end
