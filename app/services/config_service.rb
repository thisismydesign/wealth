# frozen_string_literal: true

class ConfigService < ApplicationService
  attr_accessor :key

  def call
    value = Rails.application.credentials.dig(*key)
    raise "Config key not found: #{key}" if value.nil?

    value
  end
end
