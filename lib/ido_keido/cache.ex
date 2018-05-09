defmodule IdoKeido.Cache do
  @moduledoc """
  Handle ETS cache.
  """

  require Logger

  @cache_name :geolocation_cache

  @doc """
  Cache name.
  """
  @spec cache_name() :: atom()
  def cache_name do
    @cache_name
  end

  @doc """
  Default TTL in miliseconds.
  """
  @spec default_ttl() :: non_neg_integer()
  def default_ttl do
    Application.get_env(:ido_keido, :cache)[:ttl]
    |> String.to_integer()
    |> :timer.hours()
  end

  @doc """
  Fetches a value from cache given a key.

  If `key` does not exist or is expired, set the value with the result of `get_value` function.

  ## Examples

      IdoKeido.Cache.fetch("my_key", fn -> [:one, :two] end)
      [:one, :two]

  """
  @spec fetch(String.t(), function()) :: map() | nil
  def fetch(key, get_value) when is_binary(key) and is_function(get_value) do
    {_, result} =
      Cachex.fetch(cache_name(), key, fn ->
        handle_value(key, get_value)
      end)

    result
  end

  @spec handle_value(String.t(), function()) :: {atom(), term()}
  defp handle_value(key, get_value) do
    case get_value.() do
      [] ->
        {:ignore, []}

      nil ->
        {:ignore, nil}

      value ->
        Logger.info("Cache set for key [#{key}]")
        {:commit, value}
    end
  end
end
