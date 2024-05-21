# frozen_string_literal: true

ActiveAdmin.register_page 'Tax' do
  menu priority: 4

  content title: 'Tax' do
    panel 'General Tax Overview' do
      h3 "Tax base currency: #{Rails.application.config.x.tax_base_currency}"
      h3 "Personal income tax rate: #{Rails.application.config.x.tax_rate * 100}%"
      h3 "Social tax rate: #{Rails.application.config.x.social_tax_rate * 100}%"
    end

    (Rails.application.config.x.start_year..Time.zone.today.year).to_a.reverse_each do |year|
      panel year do
        tax_base = Asset.tax_base

        div do
          panel 'Regulated transactions' do
            close_trades = Tax::ClosedPositionsService.call(year:, from_asset_type: AssetType.etf)
            open_positions = Tax::OpenPositionsService.call(year:, accept_previous_years: true,
                                                            to_asset_type: AssetType.etf)
            total_close = close_trades.sum { |trade| trade.tax_base_price&.amount || 0 }
            profits = TotalProfitsService.call(close_trades:)
            tax = profits * Rails.application.config.x.tax_rate.to_d

            h3 do
              span 'Total close: '
              optional_currency total_close, tax_base
            end

            h3 do
              span 'Total profit: '
              optional_currency profits, tax_base
            end

            h3 do
              span 'Total tax: '
              optional_currency tax, tax_base
            end

            closed_positions_table(close_trades, year, tax_base) if close_trades.any?

            open_positions_label = "Open positions (opened in #{year} or earlier)"
            open_positions_table(open_positions_label, open_positions, tax_base) if open_positions.any?
          end

          panel 'Crypto transactions' do
            Tax::ClosedPositionsService.call(year:, from_asset_type: AssetType.crypto)
            open_positions = Tax::OpenPositionsService.call(year:, accept_previous_years: false,
                                                            to_asset_type: AssetType.crypto)
            open_positions_label = "Opened positions (in #{year})"

            h3 do
              span 'Total open: '
              # TODO
            end

            h3 do
              span 'Total close: '
              # TODO
            end

            open_positions_table(open_positions_label, open_positions, tax_base) if open_positions.any?
          end

          panel 'Dividends' do
            income = Tax::TotalIncomeService.call(year:, income_type: IncomeType.dividend)
            tax = income * Rails.application.config.x.tax_rate.to_d

            h3 do
              span 'Total income: '
              optional_currency income, tax_base
            end

            h3 do
              span 'Total tax: '
              optional_currency tax, tax_base
            end
          end

          panel 'Interest' do
            income = Tax::TotalIncomeService.call(year:, income_type: IncomeType.interest)
            tax = income * Rails.application.config.x.tax_rate.to_d
            social_tax = income * Rails.application.config.x.social_tax_rate.to_d

            h3 do
              span 'Total income: '
              optional_currency income, tax_base
            end

            h3 do
              span 'Total tax: '
              optional_currency tax, tax_base
            end

            h3 do
              span 'Total social tax: '
              optional_currency social_tax, tax_base
            end
          end
        end
      end
    end
  end
end
