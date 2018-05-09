defmodule IdoKeido.City do
  @moduledoc """
  City data.
  """

  use TypedStruct

  @typedoc """
  City type.
  """
  typedstruct(enforce: true) do
    field :name, String.t()
  end
end
