defmodule IdoKeidoWeb do
  @moduledoc false
  # The entrypoint for defining your web interface, such
  # as controllers, views, channels and so on.

  # This can be used in your application as:

  #     use IdoKeidoWeb, :controller
  #     use IdoKeidoWeb, :view

  # The definitions below will be executed for every view,
  # controller, etc, so keep them short and clean, focused
  # on imports, uses and aliases.

  # Do NOT define functions inside the quoted expressions
  # below. Instead, define any helper function in modules
  # and import those modules here.

  require Protocol

  # Explicit implementation of the Jason.Encoder protocol for all geolocation structs.
  # Doing here to decouple JSON parsing from IdoKeido.Context.
  # https://hexdocs.pm/jason/readme.html#differences-to-poison
  Protocol.derive(Jason.Encoder, IdoKeido.City)
  Protocol.derive(Jason.Encoder, IdoKeido.CityResult)
  Protocol.derive(Jason.Encoder, IdoKeido.Continent)
  Protocol.derive(Jason.Encoder, IdoKeido.Country)
  Protocol.derive(Jason.Encoder, IdoKeido.CountryResult)
  Protocol.derive(Jason.Encoder, IdoKeido.Location)

  def controller do
    quote do
      use Phoenix.Controller, namespace: IdoKeidoWeb

      import Plug.Conn
      import IdoKeidoWeb.Gettext

      alias IdoKeidoWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/ido_keido_web/templates",
        namespace: IdoKeidoWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 2, view_module: 1]
      import IdoKeidoWeb.ErrorHelpers
      import IdoKeidoWeb.Gettext

      alias IdoKeidoWeb.Router.Helpers, as: Routes
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import IdoKeidoWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
