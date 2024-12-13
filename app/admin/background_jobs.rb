# frozen_string_literal: true

ActiveAdmin.register_page 'Background jobs' do
  menu priority: 99, url: '/good_job', label: '[Admin] Background jobs'
end
