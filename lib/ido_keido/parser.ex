defmodule IdoKeido.Parser do
  @moduledoc """
  Responsible to parse Geolix results to IdoKeido structs.
  """

  alias IdoKeido.{
    City,
    CityResult,
    Continent,
    Country,
    CountryResult,
    Location
  }

  alias Geolix.Adapter.MMDB2.Record, as: GeolixRecord
  alias Geolix.Adapter.MMDB2.Result, as: GeolixResult

  @doc """
  Parse Geolix city result to `IdoKeido.CountryResult` struct.
  """
  @spec city(map(), String.t()) :: CityResult.t()
  def city(
        %GeolixResult.City{
          city: city,
          location: location,
          country: country,
          continent: continent
        },
        ip
      )
      when is_binary(ip) do
    %CityResult{
      city: parse(city),
      location: parse(location),
      country: parse(country),
      continent: parse(continent),
      ip: ip
    }
  end

  @doc """
  Parse Geolix country result to `IdoKeido.CountryResult` struct.
  """
  @spec country(map(), String.t()) :: CountryResult.t()
  def country(%GeolixResult.Country{country: country, continent: continent}, ip)
      when is_binary(ip) do
    %CountryResult{
      country: parse(country),
      continent: parse(continent),
      ip: ip
    }
  end

  @spec parse(map() | nil) :: City.t() | Continent.t() | Country.t() | Location.t() | nil

  defp parse(%GeolixRecord.City{name: name}) do
    %City{name: name}
  end

  defp parse(%GeolixRecord.Location{
         accuracy_radius: accuracy_radius,
         latitude: latitude,
         longitude: longitude,
         time_zone: time_zone
       }) do
    %Location{
      accuracy_radius: accuracy_radius,
      latitude: latitude,
      longitude: longitude,
      time_zone: time_zone
    }
  end

  defp parse(%GeolixRecord.Country{iso_code: iso_code, name: name}) do
    %Country{code: iso_code, name: name}
  end

  defp parse(%GeolixRecord.Continent{code: code, name: name}) do
    %Continent{code: code, name: name}
  end

  defp parse(nil), do: nil
end
