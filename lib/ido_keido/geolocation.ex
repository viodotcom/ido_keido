defmodule IdoKeido.GeolocationContext do
  @moduledoc """
  Geolocation context behaviour.
  """

  @doc """
  Find city geolocation data by IP.
  """
  @callback city(ip :: String.t()) :: map() | nil

  @doc """
  Find country geolocation data by IP.
  """
  @callback country(ip :: String.t()) :: map() | nil
end

defmodule IdoKeido.Geolocation do
  @moduledoc """
  Implementation of `IdoKeido.GeolocationContext` behaviour.
  """

  @behaviour IdoKeido.GeolocationContext

  alias IdoKeido.{Cache, CityResult, CountryResult, Parser}

  @default_locale :en
  @repo Application.get_env(:ido_keido, :injections)[:repo]

  @impl true
  def city(ip) when is_binary(ip), do: get(ip, :city)

  @impl true
  def country(ip) when is_binary(ip), do: get(ip, :country)

  @spec cache_key(String.t(), atom()) :: String.t()
  defp cache_key(ip, type) do
    "#{type}_#{ip}"
  end

  @spec get(String.t(), atom()) :: map() | nil
  defp get(ip, type) do
    ip
    |> cache_key(type)
    |> Cache.fetch(fn -> get_from_db(ip, type) end)
  end

  @spec get_from_db(String.t(), atom()) :: CityResult.t() | CountryResult.t() | nil
  defp get_from_db(ip, type) do
    ip
    |> @repo.lookup(locale: @default_locale, where: type)
    |> case do
      nil -> nil
      result -> apply(Parser, type, [result, ip])
    end
  end
end
