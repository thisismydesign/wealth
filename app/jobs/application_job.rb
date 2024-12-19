# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  include Rollbar::ActiveJob
  retry_on StandardError, wait: :polynomially_longer, attempts: 10
end
