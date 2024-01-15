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
        tax_currency = Asset.tax_base
        close_trades = ClosedPositionsService.call(year:)
        open_positions = OpenPositionsService.call(year:)
        total_close = close_trades.sum { |trade| trade.to_price_in(tax_currency) }

        div do
          profits = TotalProfitsService.call(close_trades:)
          income = TotalIncomeService.call(year:)
          tax = (income + profits) * Rails.application.config.x.tax_rate.to_d

          h3 do
            span 'Total close: '
            span "#{formatted_currency(total_close)} #{tax_currency.ticker}", class: 'secret'
          end
          h3 do
            span 'Total profit: '
            span "#{formatted_currency(profits)} #{tax_currency.ticker}", class: 'secret'
          end
          h3 do
            span 'Total income: '
            span "#{formatted_currency(income)} #{tax_currency.ticker}", class: 'secret'
          end
          h3 do
            span 'Total tax: '
            span "#{formatted_currency(tax)} #{tax_currency.ticker}", class: 'secret'
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

              column 'Tax base close price', class: 'secret' do |trade|
                if trade.tax_base_trade_price.present?
                  "#{formatted_currency(trade.tax_base_trade_price.amount)} #{tax_currency.ticker}"
                else
                  'N/A'
                end
              end

              column 'Tax base profit', class: 'secret' do |trade|
                profit = CalculateProfitService.call(close_trade: trade)

                if profit.present?
                  "#{formatted_currency(profit)} #{tax_currency.ticker}"
                else
                  'N/A'
                end
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
