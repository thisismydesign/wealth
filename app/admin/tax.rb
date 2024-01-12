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
        closed_trades = ClosedPositionsService.call(year:)
        open_trades = OpenPositionsService.call(year:)
        Rails.logger.debug open_trades
        tax_currency = TaxCurrencyService.call
        total_close = closed_trades.sum { |trade| trade.to_price_in(tax_currency) }

        div do
          profits = TotalProfitsService.call(close_trades: closed_trades)
          income = TotalIncomeService.call(year:)
          tax = (income + profits) * Rails.application.config.x.tax_rate.to_d

          h3 do
            span 'Total close: '
            span "#{formatted_currency(total_close)} #{tax_currency.ticker_or_name}", class: 'secret'
          end
          h3 do
            span 'Total profit: '
            span "#{formatted_currency(profits)} #{tax_currency.ticker_or_name}", class: 'secret'
          end
          h3 do
            span 'Total income: '
            span "#{formatted_currency(income)} #{tax_currency.ticker_or_name}", class: 'secret'
          end
          h3 do
            span 'Total tax: '
            span "#{formatted_currency(tax)} #{tax_currency.ticker_or_name}", class: 'secret'
          end
        end

        if closed_trades.any?
          panel 'Closed positions' do
            table_for closed_trades do
              column :name, class: 'secret' do |trade|
                link_to(
                  trade.humanized, admin_trade_path(trade), class: 'secret'
                )
              end

              column :date do |trade|
                trade.date.strftime('%Y.%m.%d')
              end
              column :from_amount, class: 'secret'
              column :from
              column :to_amount, class: 'secret'
              column :to
              column 'Tax base close price', class: 'secret' do |trade|
                price = trade.to_price_in(tax_currency)
                "#{formatted_currency(price)} #{tax_currency.ticker_or_name}"
              end
              column 'Tax base profit', class: 'secret' do |trade|
                profit = CalculateProfitService.call(close_trade: trade, currency: tax_currency)
                "#{formatted_currency(profit)} #{tax_currency.ticker_or_name}"
              end
            end
          end
        end

        if open_trades.any?
          panel 'Open positions' do
            table_for open_trades do
              column :name, class: 'secret', &:humanized

              column :from_amount, class: 'secret'
              column :from
              column :to_amount, class: 'secret'
              column :to
            end
          end
        end
      end
    end
  end
end
