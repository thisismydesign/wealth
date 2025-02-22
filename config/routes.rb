# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root to: 'admin/tax#index'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  post 'imports/activity_from_kraken', to: 'imports#activity_from_kraken'

  authenticate :user, ->(u) { u.admin? } do
    mount SolidQueueDashboard::Engine, at: '/solid-queue'
  end
end
