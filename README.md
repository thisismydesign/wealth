# Wealth

https://wealth.mysoftware.services/

### Asset & tax management

Supports:
- Import exchange rates from MNB
- Manually adding assets, trades, income
- Import activity (trades, staking) from Kraken
- Tax calculation for crypto using the "back box" method
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
- Asset value conversion to tax base currency happens according to Hungarian tax law (i.e. when exchange rate is not available the app will use previous available date).
