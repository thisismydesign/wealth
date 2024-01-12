# Wealth

### Asset & tax management

Supports:
- Import exchange rates from MNB
- Import rates from Google Finance through a public google spreadsheet
- Import activity (trades, dividends, deposit, withdrawal) from IBKR
- Import activity (trades, staking) from Kraken
- Tax calculation in custom currency using FIFO method

### Usage

```sh
cp .env.example .env
# Fill values in .env

docker-compose up
```

#### Caveats

- Set config in `application.rb`
- Assets need to be added manually to be recognized
- Tax calculation does not support tradinf between non-currency assets. I.e. USD -> BTC & BTC -> USD is supported, but BTC -> ETH is not.
- IBKR export does not differentiate between tickers on different exchanges (e.g. LSTEEF, AEB). Make sure only one ticket with the same name is available.
- Fees are not handled separately. They're added to costs or subtracted from proceeds.
