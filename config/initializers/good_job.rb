# frozen_string_literal: true

Rails.application.configure do
  config.good_job.enable_cron = true
  config.good_job.cron = {
    import: {
      class: 'ImportJob',
      cron: '0 6 * * *' # Every day at 6:00am
    }
  }
end
