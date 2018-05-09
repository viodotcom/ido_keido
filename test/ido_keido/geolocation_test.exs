defmodule IdoKeido.GeolocationTest do
  use ExUnit.Case, async: true
  import Mox

  alias IdoKeido.Geolocation, as: Subject

  alias IdoKeido.{
    Cache,
    City,
    CityResult,
    Continent,
    Country,
    CountryResult,
    Location,
    RepoMock
  }

  alias Geolix.Adapter.MMDB2.Record, as: GeolixRecord
  alias Geolix.Adapter.MMDB2.Result, as: GeolixResult

  # Using Mox global mode to be able to use RepoMock inside a function that is passed to
  # Cache module as a parameter.
  setup :set_mox_global

  # Make sure mocks are verified when the test exits
  setup :verify_on_exit!

  @ip "134.201.250.155"
  @locale :en

  @country_result %CountryResult{
    country: %Country{
      code: "US",
      name: "United States"
    },
    continent: %Continent{
      code: "NA",
      name: "North America"
    },
    ip: @ip
  }

  @city_result %CityResult{
    city: %City{
      name: "Los Angeles"
    },
    location: %Location{
      accuracy_radius: 5,
      latitude: 34.0544,
      longitude: -118.244,
      time_zone: "America/Los_Angeles"
    },
    country: %Country{
      code: "US",
      name: "United States"
    },
    continent: %Continent{
      code: "NA",
      name: "North America"
    },
    ip: @ip
  }

  describe "#city/1 when IP is found in cache" do
    setup do
      put_in_cache("city_#{@ip}", @city_result)

      on_exit(fn -> clear_cache() end)

      {:ok, city_result: @city_result}
    end

    test "returns city data from cache", %{city_result: expected_city_result} do
      assert Subject.city(@ip) == expected_city_result
    end
  end

  describe "#city/1 when IP is not found in cache, but is found in DB" do
    setup do
      raw_city = %GeolixResult.City{
        city: %GeolixRecord.City{
          geoname_id: 5_368_361,
          name: "Los Angeles"
        },
        continent: %GeolixRecord.Continent{
          geoname_id: 6_255_149,
          code: "NA",
          name: "North America"
        },
        country: %GeolixRecord.Country{
          geoname_id: 6_252_001,
          iso_code: "US",
          name: "United States"
        },
        location: %GeolixRecord.Location{
          accuracy_radius: 5,
          latitude: 34.0544,
          longitude: -118.244,
          metro_code: 803,
          time_zone: "America/Los_Angeles"
        }
      }

      RepoMock
      |> stub(:lookup, fn @ip, locale: @locale, where: :city -> raw_city end)

      on_exit(fn -> clear_cache() end)

      {:ok, city_result: @city_result}
    end

    test "returns city data from DB", %{city_result: expected_city_result} do
      assert Subject.city(@ip) == expected_city_result
    end
  end

  describe "#city/1 when IP is not found in cache, and is not found in DB as well" do
    setup do
      RepoMock
      |> stub(:lookup, fn @ip, locale: @locale, where: :city -> nil end)

      :ok
    end

    test "returns nil" do
      assert Subject.city(@ip) == nil
    end
  end

  describe "#country/1 when IP is found in cache" do
    setup do
      put_in_cache("country_#{@ip}", @country_result)

      on_exit(fn -> clear_cache() end)

      {:ok, country_result: @country_result}
    end

    test "returns country data from cache", %{country_result: expected_country_result} do
      assert Subject.country(@ip) == expected_country_result
    end
  end

  describe "#country/1 when IP is not found in cache, but is found in DB" do
    setup do
      raw_country = %GeolixResult.Country{
        continent: %GeolixRecord.Continent{
          geoname_id: 6_255_149,
          code: "NA",
          name: "North America"
        },
        country: %GeolixRecord.Country{
          geoname_id: 6_252_001,
          iso_code: "US",
          name: "United States"
        }
      }

      RepoMock
      |> stub(:lookup, fn @ip, locale: @locale, where: :country -> raw_country end)

      on_exit(fn -> clear_cache() end)

      {:ok, country_result: @country_result}
    end

    test "returns country data from DB", %{country_result: expected_country_result} do
      assert Subject.country(@ip) == expected_country_result
    end
  end

  describe "#country/1 when IP is not found in cache, and is not found in DB as well" do
    setup do
      RepoMock
      |> stub(:lookup, fn @ip, locale: @locale, where: :country -> nil end)

      :ok
    end

    test "returns nil" do
      assert Subject.country(@ip) == nil
    end
  end

  defp put_in_cache(key, value) do
    Cache.cache_name() |> Cachex.put(key, value)
  end

  defp clear_cache do
    Cache.cache_name() |> Cachex.clear()
  end
end
