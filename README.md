# Rails Docker boilerplate

#### A boilerplate that sets the ground for Rails development with Docker

## Usage

```sh
# Create new rails app (customize according to your need)
docker-compose run --rm web rails new . --force --api --database=postgresql --skip-git
# Fix issues (e.g. edit config/database.yml) and then
docker-compose up
```

## License

The project is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
