defmodule IdoKeido.CityResult do
  @moduledoc """
  City result of a geolocation lookup.
  """

  use TypedStruct

  alias IdoKeido.{City, Continent, Country, Location}

  @typedoc """
  City result type.
  """
  typedstruct(enforce: true) do
    field :city, City.t()
    field :location, Location.t()
    field :country, Country.t()
    field :continent, Continent.t()
    field :ip, String.t()
  end
end
