defmodule IdoKeido.CountryResult do
  @moduledoc """
  Country result of a geolocation lookup.
  """

  use TypedStruct

  alias IdoKeido.{Continent, Country}

  @typedoc """
  Country result type.
  """
  typedstruct(enforce: true) do
    field :country, Country.t()
    field :continent, Continent.t()
    field :ip, String.t()
  end
end
