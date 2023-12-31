# frozen_string_literal: true

ActiveAdmin.register_page 'Tax' do
  content title: 'Tax Information' do
    panel 'General Tax Overview' do
      div do
        'Summary of general tax information...'
        # You can add more HTML elements or Ruby code to display data
      end
    end

    (Rails.application.config.x.start_year..Time.zone.today.year).to_a.reverse_each do |year|
      panel "#{year} closed positions" do
        trades = ClosedPositionsService.call(year:)

        table_for trades do
          column :name do |resource|
            link_to(
              resource.humanized, admin_trade_path(resource)
            )
          end

          column :date
          column :from_amount
          column :from
          column :to_amount
          column :to
        end
      end
    end
  end
end
