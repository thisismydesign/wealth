# frozen_string_literal: true

class UserPolicy < AdminPolicy
  def show?
    super || user == record
  end

  def update?
    show?
  end
end
