defmodule IdoKeido.Repo do
  @moduledoc """
  Repository behaviour.
  """

  @callback lookup(ip :: String.t(), options :: Keyword.t()) :: map() | nil
end
