# frozen_string_literal: true

ActiveAdmin.register_page 'Tax' do
  content title: 'Tax Information' do
    panel 'General Tax Overview' do
      h3 "Tax rate: #{Rails.application.config.x.tax_rate * 100}%"
      h3 "Tax base currency: #{Rails.application.config.x.tax_base_currency}"
    end

    (Rails.application.config.x.start_year..Time.zone.today.year).to_a.reverse_each do |year|
      panel "#{year} closed positions" do
        trades = ClosedPositionsService.call(year:)
        tax_currency = Asset.find_by(ticker: Rails.application.config.x.tax_base_currency,
                                     asset_type: AssetType.currency)

        div class: 'total-tax-amount' do
          tax = TotalTaxesService.call(close_trades: trades)
          h3 "Total Tax Amount: #{formatted_currency(tax)} #{tax_currency.ticker_or_name}"
        end

        table_for trades do
          column :name do |trade|
            link_to(
              trade.humanized, admin_trade_path(trade)
            )
          end

          column :date
          column :from_amount
          column :from
          column :to_amount
          column :to
          column :tax_base_close_price do |trade|
            converted_amount = CurrencyConverterService.call(from: trade.to, to: tax_currency, date: trade.date,
                                                             amount: trade.to_amount)
            "#{formatted_currency(converted_amount)} #{tax_currency.ticker_or_name}"
          end
        end
      end
    end
  end
end
