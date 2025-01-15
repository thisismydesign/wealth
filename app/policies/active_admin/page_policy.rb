# frozen_string_literal: true

module ActiveAdmin
  class PagePolicy < ApplicationPolicy
    def show?
      case record.name
      when 'About', 'Tax'
        true
      when 'Import'
        user.user?
      when 'Background jobs'
        user.admin?
      else
        false
      end
    end
  end
end
