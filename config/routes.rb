# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  ActiveAdmin.routes(self)

  root to: 'admin/dashboard#index'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  get 'imports/exchange_rates_from_mnb', to: 'imports#exchange_rates_from_mnb'
  get 'imports/rates_from_googlefinance', to: 'imports#rates_from_googlefinance'
  post 'imports/activity_from_ibkr', to: 'imports#activity_from_ibkr'
  post 'imports/activity_from_kraken', to: 'imports#activity_from_kraken'
  post 'imports/activity_from_wise', to: 'imports#activity_from_wise'

  mount GoodJob::Engine => 'good_job'
end
