defmodule IdoKeidoWeb.GeolocationController do
  @moduledoc """
  Controller for geolocation.
  """

  use IdoKeidoWeb, :controller

  @geolocation Application.get_env(:ido_keido, :injections)[:geolocation]

  @doc """
  Returns city geolocation data for the given IP.
  """
  def city(conn, %{"ip" => ip}) do
    case @geolocation.city(ip) do
      nil -> send_resp(conn, 404, "")
      city -> json(conn, city)
    end
  end

  @doc """
  Returns country geolocation data for the given IP.
  """
  def country(conn, %{"ip" => ip}) do
    case @geolocation.country(ip) do
      nil -> send_resp(conn, 404, "")
      country -> json(conn, country)
    end
  end
end
