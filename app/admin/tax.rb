# frozen_string_literal: true

ActiveAdmin.register_page 'Tax' do
  content title: 'Tax' do
    panel 'General Tax Overview' do
      h3 "Tax rate: #{Rails.application.config.x.tax_rate * 100}%"
      h3 "Tax base currency: #{Rails.application.config.x.tax_base_currency}"
    end

    (Rails.application.config.x.start_year..Time.zone.today.year).to_a.reverse_each do |year|
      panel "#{year} closed positions" do
        trades = ClosedPositionsService.call(year:)
        tax_currency = Asset.find_by(ticker: Rails.application.config.x.tax_base_currency,
                                     asset_type: AssetType.currency)
        total_close = trades.sum { |trade| trade.to_price_in(tax_currency) }

        div do
          profits = TotalProfitsService.call(close_trades: trades)
          tax = profits * Rails.application.config.x.tax_rate.to_d

          h3 "Total close: #{formatted_currency(total_close)} #{tax_currency.ticker_or_name}"
          h3 "Total profit: #{formatted_currency(profits)} #{tax_currency.ticker_or_name}"
          h3 "Total tax: #{formatted_currency(tax)} #{tax_currency.ticker_or_name}"
        end

        table_for trades do
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
  end
end
