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
        tax_base = Asset.tax_base
        close_trades = ClosedPositionsService.call(year:)
        open_positions = OpenPositionsService.call(year:)
        total_close = close_trades.sum { |trade| trade.tax_base_price&.amount || 0 }

        div do
          profits = TotalProfitsService.call(close_trades:)
          income = TotalTaxableIncomeService.call(year:)
          tax = (income + profits) * Rails.application.config.x.tax_rate.to_d

          h3 do
            span 'Total close: '
            optional_currency total_close, tax_base
          end
          h3 do
            span 'Total profit: '
            optional_currency profits, tax_base
          end
          h3 do
            span 'Total income: '
            optional_currency income, tax_base
          end
          h3 do
            span 'Total tax: '
            optional_currency tax, tax_base
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

              column :open_price do |trade|
                optional_currency CalculateOpenPriceService.call(close_trade: trade), tax_base
              end

              column :close_price do |trade|
                optional_currency trade.tax_base_price&.amount, tax_base
              end

              column :profit do |trade|
                open_price = CalculateOpenPriceService.call(close_trade: trade)
                profit = CalculateProfitService.call(close_trade: trade)
                percentage_profit = profit / open_price * 100

                optional_currency profit, tax_base
                span " (#{percentage_profit.round(2)}%)"
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
