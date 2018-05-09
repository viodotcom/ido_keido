# Development

## Core dependencies

  * Elixir 1.8+ ([http://elixir-lang.org/install.html](http://elixir-lang.org/install.html))
  * Phoenix 1.4+ ([http://www.phoenixframework.org/docs/installation](http://www.phoenixframework.org/docs/installation))
  * MaxMind Geolocation Databases (see [Databases](#databases) below)


## Databases

First of all download the geolocation databases.

For GeoLite2 databases (free version):
```sh
make download-databases
```

For MaxMind’s GeoIP2 databases (paid version), use your MaxMind license keys for each database:
```sh
COUNTRY_DB_KEY=YOUR_LICENSE_KEY CITY_DB_KEY=YOUR_LICENSE_KEY make download-databases
```

Country and city databases will be downloaded to `[application_root]/data` directory. Do not change
the names of the database files.


## Local environment

 Install application dependencies:
```sh
mix deps.get
```

Compile the application.
```sh
mix compile
```

### Running

#### Web server
```sh
mix phx.server
```
Ido Keido API will be available on **http:://localhost:4004**.

#### Iex
```sh
iex -S mix
```

```elixir
iex> IdoKeido.Geolocation.country("95.97.71.51")
%IdoKeido.CountryResult{
  continent: %IdoKeido.Continent{code: "EU", name: "Europe"},
  country: %IdoKeido.Country{code: "NL", name: "Netherlands"},
  ip: "95.97.71.51"
}
```

```elixir
iex> IdoKeido.Geolocation.city("95.97.71.51")
%IdoKeido.CityResult{
  city: %IdoKeido.City{name: "Amsterdam"},
  continent: %IdoKeido.Continent{code: "EU", name: "Europe"},
  country: %IdoKeido.Country{code: "NL", name: "Netherlands"},
  ip: "95.97.71.51",
  location: %IdoKeido.Location{
    accuracy_radius: 1,
    latitude: 52.3709,
    longitude: 4.8816,
    time_zone: "Europe/Amsterdam"
  }
}
```

### Testing

Run test suite:
```sh
mix test --trace
```

Run test coverage report:
```sh
mix coveralls
```


## Using Docker

Build the Docker image:
```sh
make docker-build
```

### Running

#### Web server
```sh
make docker-run
```
Ido Keido API will be available on **http:://localhost:4004**.

#### Iex
```sh
make docker-iex
```

## Troubles

If there is any step missing in this documentation, don't hesitate to add it and open a pull request. :wink:
