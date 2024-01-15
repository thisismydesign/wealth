# frozen_string_literal: true

ActiveAdmin.register_page 'Tax' do
  menu priority: 4

  content title: 'Tax' do
    panel 'General Tax Overview' do
      h3 "Tax rate: #{Rails.application.config.x.tax_rate * 100}%"
      h3 "Tax base currency: #{Rails.application.config.x.tax_base_currency}"
    end

    (Rails.application.config.x.start_year..Time.zone.today.year).to_a.reverse_each do |year|
      panel year do
        close_trades = ClosedPositionsService.call(year:)
        open_positions = OpenPositionsService.call(year:)
        total_close = close_trades.sum { |trade| trade.tax_base_trade_price&.amount || 0 }

        div do
          profits = TotalProfitsService.call(close_trades:)
          income = TotalIncomeService.call(year:)
          tax = (income + profits) * Rails.application.config.x.tax_rate.to_d

          h3 do
            span 'Total close: '
            tax_value total_close
          end
          h3 do
            span 'Total profit: '
            tax_value profits
          end
          h3 do
            span 'Total income: '
            tax_value income
          end
          h3 do
            span 'Total tax: '
            tax_value tax
          end
        end

        if close_trades.any?
          panel 'Closed positions' do
            table_for close_trades do
              column :name do |trade|
                humanized_trade trade
              end

              column :date do |trade|
                trade.date.strftime('%Y.%m.%d')
              end

              rouned_value :from_amount
              asset_link :from

              rouned_value :to_amount
              asset_link :to

              column 'Tax base close price' do |trade|
                tax_value trade.tax_base_trade_price&.amount
              end

              column 'Tax base profit' do |trade|
                tax_value CalculateProfitService.call(close_trade: trade)
              end
            end
          end
        end

        if open_positions.any?
          panel 'Open positions' do
            table_for open_positions do
              column :name do |trade|
                humanized_trade trade
              end

              rouned_value :from_amount
              asset_link :from

              rouned_value :to_amount
              asset_link :to
            end
          end
        end
      end
    end
  end
end
