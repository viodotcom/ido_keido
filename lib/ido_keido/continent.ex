defmodule IdoKeido.Continent do
  @moduledoc """
  Continent data.
  """

  use TypedStruct

  @typedoc """
  Continent type.
  """
  typedstruct(enforce: true) do
    field :code, String.t()
    field :name, String.t()
  end
end
