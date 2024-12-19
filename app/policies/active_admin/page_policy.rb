# frozen_string_literal: true

module ActiveAdmin
  class PagePolicy < ApplicationPolicy
    def show?
      case record.name
      when 'Tax', 'Import'
        true
      when 'Dashboard', 'Background jobs'
        user.admin?
      else
        false
      end
    end
  end
end
