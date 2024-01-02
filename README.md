# Wealth

### Asset & tax management

Supports:
- Import exchange rates from MNB
- Import activity (trades, deposit, withdrawal) from IBKR

#### Caveats

- Set config in `application.rb`
- Assets need to be added manually to be recognized
- IBKR export does not differentiate between tickers on different exchanges (e.g. LSTEEF, AEB). Make sure only one ticket with the same name is available.
