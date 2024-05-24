# Wealth

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

### Asset & tax management

Supports:
- Import exchange rates from MNB
- Import rates from Google Finance through a [public google spreadsheet](https://docs.google.com/spreadsheets/d/1sengA50qeOqxxVPKAOQmGLRyTjkzSJMI8bBMtJzwQEc)
- Import activity (trades, dividends, deposit, withdrawal) from IBKR
- Import activity (trades, staking) from Kraken
- Tax calculation in custom currency using FIFO method
- Personalized seeds to load existing data programatically
- Store asset prices in different currencies, such as tax base and trade base currencies

### Usage

```sh
docker-compose up
```

Tools:

```sh
docker-compose exec web bin/rails credentials:decrypt
docker-compose exec web bin/rails credentials:encrypt
```

#### Caveats

- Set config in `application.rb`
- Assets need to be added manually to be recognized
- Tax calculation does not support trading between non-currency assets. I.e. USD -> BTC & BTC -> USD is supported, but BTC -> ETH is not.
- IBKR export does not differentiate between tickers on different exchanges (e.g. LSTEEF, AEB). Make sure only one ticket with the same name is available.
- Fees are not handled separately. They're added to costs or subtracted from proceeds.
- Asset value conversion to tax base currency happens according to Hungarian tax law (i.e. when exchange rate is not available the app will use previous available date).
