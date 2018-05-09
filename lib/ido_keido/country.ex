defmodule IdoKeido.Country do
  @moduledoc """
  Country data.
  """

  use TypedStruct

  @typedoc """
  Country type.
  """
  typedstruct(enforce: true) do
    field :code, String.t()
    field :name, String.t()
  end
end
