defmodule IdoKeidoWeb.Router do
  @moduledoc false

  use IdoKeidoWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", IdoKeidoWeb do
    pipe_through(:api)

    get("/city/:ip", GeolocationController, :city, as: :city)
    get("/country/:ip", GeolocationController, :country, as: :country)
    get("/status", StatusController, :index)
  end
end
