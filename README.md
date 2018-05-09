![Ido Keido](https://github.com/FindHotel/ido_keido/blob/master/docs/ido_keido_logo.png)

# Ido Keido

"Ido Keido" (緯度経度) in Japanese means "Latitude Longitude" 🌐 🇯🇵

Ido Keido is an open source geolocation service API to determine city, location, country, and
continent from given IP addresses, using [MaxMind](https://www.maxmind.com) Country and City
geolocation binary databases, with support for both IPv4 and IPv6 formats.

Ido Keido was initially created as an internal application at [FindHotel](http://company.findhotel.net).
Nowadays it is used as a base application for the same internal geolocation service.

MaxMind provides free and paid versions of geolocation databases:
- GeoLite2 free downloadable databases (less accurate than MaxMind’s GeoIP2 databases): https://dev.maxmind.com/geoip/geoip2/geolite2
- MaxMind’s GeoIP2 databases: City (https://www.maxmind.com/en/geoip2-city) and Country (https://www.maxmind.com/en/geoip2-country-database)

Both binary databases versions are supported by Ido Keido.

## Technologies

### Elixir

![Elixir](https://camo.githubusercontent.com/9c090491439e7054b157aeaf27a709c7679105cf/68747470733a2f2f656c697869722d6c616e672e6f72672f696d616765732f6c6f676f2f6c6f676f2e706e67)

Ido Keido was proudly built using [Elixir](https://elixir-lang.org), a dynamic and functional
programming language designed for building scalable and maintainable applications.

### Cache with ETS

![Erlang](https://camo.githubusercontent.com/6d67ad5ca0b8874af6c47201378129fbe1b0c503/687474703a2f2f7777772e65726c616e672e6f72672f696d672f65726c616e672e706e67)

Each result of a lookup by IP on the databases is cached on [ETS (Erlang Term Storage)](http://erlang.org/doc/man/ets.html),
caching distinctly city and country results by IP. Subsequent requests using the same IP will
retrieve the data from cache, avoiding a new lookup on the database.

ETS, a powerful storage engine built into OTP and available to use in Elixir, allows us to store
any Elixir term in an in-memory table.

For more details about ETS as a cache see https://elixir-lang.org/getting-started/mix-otp/ets.html#ets-as-a-cache.

### Docker

![Docker](https://camo.githubusercontent.com/0736f7d8a1c6dd57b9bf46eca5cb3ba70bd3fe5c/68747470733a2f2f75706c6f61642e77696b696d656469612e6f72672f77696b6970656469612f636f6d6d6f6e732f7468756d622f342f34652f446f636b65725f253238636f6e7461696e65725f656e67696e652532395f6c6f676f2e7376672f33303070782d446f636b65725f253238636f6e7461696e65725f656e67696e652532395f6c6f676f2e7376672e706e67)

Ido Keido application is published as a Docker image in Docker Hub: https://hub.docker.com/r/findhotel/ido_keido


## Usage

The Ido Keido's Docker image provides a way to run the geolocation service API out of the box.

The geolocation databases are not included in the Docker image. You need to download the MaxMind
Country and City geolocation binary databases prior to run the application and rename the database
files as following:
- Country database: `country.mmdb`
- Country database: `city.mmdb`

In order to download the databases, you can:
- Download direct from [MaxMind website](https://dev.maxmind.com/geoip/geoip2/geolite2); or
- Clone the [Ido Keido's Github repository](https://github.com/FindHotel/ido_keido) and run the make command `download-databases`, that downloads the databases to `[application_root]/data` directory and renames the database files them properly.
```
make download-databases
```

In the "Development" documentation of Ido Keidos's Github repository you find [the usage details of `download-databases` make command](https://github.com/FindHotel/ido_keido/blob/master/docs/development.md)

Once the database files as available in your machine, (pull and) run the Docker image setting the
volume parameter (`-v`) with the local database directory.

```
docker run -e PORT=4004 -v <full_path_to_databases>:/opt/app/data  -p 4004:4004 --rm -it findhotel/ido_keido
```

Ido Keido API will be available on **http:://localhost:4004**. For example, retrieving country information: [http://localhost:4004/country/2a02:a210:1580:6100:ecf5:e0b7:e7e5:84a1](http://localhost:4004/country/2a02:a210:1580:6100:ecf5:e0b7:e7e5:84a1). The complete list of endpoints is described in "API Endpoints" section. 

To run IEx (Elixir's Interactive Shell) from the Docker image use the following command:
```
docker run -e PORT=4004 -v <full_path_to_databases>:/opt/app/data --rm -it findhotel/ido_keido bin/ido_keido console
```

### Extending for your own application

TODO


## API Endpoints

### GET /country/:ip
```
http://localhost:4004/country/95.97.71.51

{
  "continent": {
    "code": "EU",
    "name": "Europe"
  },
  "country": {
    "code": "NL",
    "name": "Netherlands"
  },
  "ip": "95.97.71.51"
}
```

### GET /city/:ip
```
http://localhost:4004/city/95.97.71.51

{
  "city": {
    "name": "Amsterdam"
  },
  "continent": {
    "code": "EU",
    "name": "Europe"
  },
  "country": {
    "code": "NL",
    "name": "Netherlands"
  },
  "ip": "95.97.71.51",
  "location": {
    "accuracy_radius": 5,
    "latitude": 52.3551,
    "longitude": 4.8788,
    "time_zone": "Europe/Amsterdam"
  }
}
```

### GET /status
```
http://localhost:4004/status

{
  "date_time": "2019-03-14T16:04:16.027180Z",
  "status": "ok"
}
```

## Development

See the [development instructions](https://github.com/FindHotel/ido_keido/blob/master/docs/development.md).


## Contributing

See the [contributing guide](https://github.com/FindHotel/ido_keido/blob/master/CONTRIBUTING.md).

## License

Ido Keido is released under the Apache 2.0 License. See the [LICENSE](https://github.com/FindHotel/ido_keido/blob/master/LICENSE) file.

Ido Keido uses GeoLite2 data created by MaxMind, available from https://www.maxmind.com.

## Maintainers

- [FindHotel](https://github.com/FindHotel)
- [Antonio Lorusso (zekus)](https://github.com/zekus)
- [Fernando Hamasaki de Amorim (prodis)](https://github.com/prodis)
