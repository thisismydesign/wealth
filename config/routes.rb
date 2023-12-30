# frozen_string_literal: true

Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  root to: 'admin#admin'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  get 'imports/exchange_rates_from_mnb', to: 'imports#exchange_rates_from_mnb'
end
