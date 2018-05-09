defmodule IdoKeido.Location do
  @moduledoc """
  Location data.
  """

  use TypedStruct

  @typedoc """
  Location type.
  """
  typedstruct(enforce: true) do
    field :accuracy_radius, integer()
    field :latitude, float()
    field :longitude, float()
    field :time_zone, String.t()
  end
end
