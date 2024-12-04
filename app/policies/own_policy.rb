# frozen_string_literal: true

class OwnPolicy < AdminPolicy
  def index?
    true
  end

  def create?
    true
  end

  def show?
    super || record.user_id == user.id
  end

  def update?
    super || record.user_id == user.id
  end

  def destroy?
    super || record.user_id == user.id
  end

  class Scope < AdminPolicy::Scope
    def resolve
      super.presence || scope.where(user_id: user.id)
    end
  end
end
