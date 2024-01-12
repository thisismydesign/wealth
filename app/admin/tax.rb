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

          h3 "Total close: #{formatted_currency(total_close)} #{tax_currency.ticker_or_name}"
          h3 "Total profit: #{formatted_currency(profits)} #{tax_currency.ticker_or_name}"
          h3 "Total income: #{formatted_currency(income)} #{tax_currency.ticker_or_name}"
          h3 "Total tax: #{formatted_currency(tax)} #{tax_currency.ticker_or_name}"
        end

        if closed_trades.any?
          panel 'Closed positions' do
            table_for closed_trades do
              column :name do |trade|
                link_to(
                  trade.humanized, admin_trade_path(trade)
                )
              end

              column :date do |trade|
                trade.date.strftime('%Y.%m.%d')
              end
              column :from_amount
              column :from
              column :to_amount
              column :to
              column 'Tax base close price' do |trade|
                price = trade.to_price_in(tax_currency)
                "#{formatted_currency(price)} #{tax_currency.ticker_or_name}"
              end
              column 'Tax base profit' do |trade|
                profit = CalculateProfitService.call(close_trade: trade, currency: tax_currency)
                "#{formatted_currency(profit)} #{tax_currency.ticker_or_name}"
              end
            end
          end
        end

        if open_trades.any?
          panel 'Open positions' do
            table_for open_trades do
              column :name, &:humanized

              column :from_amount
              column :from
              column :to_amount
              column :to
            end
          end
        end
      end
    end
  end
end
