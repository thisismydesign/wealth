# Wealth

https://wealth.mysoftware.services/

### Asset & tax management

Supports:
- Import exchange rates from MNB
- Manually adding assets, trades, income
- Import activity (trades, staking) from Kraken
- Tax calculation for crypto using the "black box" method
- Store asset prices in different currencies, such as tax base and trade base currencies

### Usage

```sh
docker compose up
```

Tools:

```sh
docker compose exec web bin/rails credentials:decrypt
docker compose exec web bin/rails credentials:encrypt
```

Production:

```sh
ssh -i ~/.ssh/hetzner root@157.180.24.197
# Web console
docker exec -it $(docker ps | grep wealth-web | awk '{print $1}') /bin/bash
# Manual backup
docker exec $(docker ps | grep wealth-backup | awk '{print $1}') sh backup.sh
```

#### Caveats

- Set config in `application.rb`
- Asset value conversion to tax base currency happens according to Hungarian tax law (i.e. when exchange rate is not available the app will use previous available date).
