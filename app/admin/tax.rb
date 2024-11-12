# frozen_string_literal: true

ActiveAdmin.register_page 'Tax' do
  menu priority: 4

  content title: 'Tax' do
    panel 'General Tax Overview' do
      h4 "Tax base currency: #{Rails.application.config.x.tax_base_currency}"
      h4 "Personal income tax rate: #{Rails.application.config.x.tax_rate * 100}%"
      h4 "Social tax rate: #{Rails.application.config.x.social_tax_rate * 100}%"
    end

    tabs do
      (Rails.application.config.x.start_year..Time.zone.today.year).reverse_each do |year|
        tab year.to_s do
          render partial: 'admin/tax/tax', locals: { year: }
        end
      end
    end
  end
end
