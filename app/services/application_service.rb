# frozen_string_literal: true

class ApplicationService
  include ActiveModel::Model

  def self.call(**args)
    new(**args).call
  end
end
