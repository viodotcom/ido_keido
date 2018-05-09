defmodule IdoKeidoWeb.StatusController do
  @moduledoc """
  Controller for status.
  """

  use IdoKeidoWeb, :controller

  @doc """
  Returns status and date/time.
  """
  def index(conn, _params) do
    response = %{
      status: "ok",
      date_time: DateTime.utc_now()
    }

    json(conn, response)
  end
end
