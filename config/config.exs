use Mix.Config

config :phoenix, :json_library, Jason

# Configures the endpoint
config :ido_keido, IdoKeidoWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: IdoKeidoWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: IdoKeido.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# TODO: Move TTL value to an environment variable.
config :ido_keido, :cache,
  # hours
  ttl: "24"

config :ido_keido, :injections,
  geolocation: IdoKeido.Geolocation,
  repo: Geolix

config :geolix,
  databases: [
    %{
      id: :city,
      adapter: Geolix.Adapter.MMDB2,
      source: Path.join([File.cwd!(), "data/city.mmdb"])
    },
    %{
      id: :country,
      adapter: Geolix.Adapter.MMDB2,
      source: Path.join([File.cwd!(), "data/country.mmdb"])
    }
  ]

# Import environment specific config.
import_config "#{Mix.env()}.exs"
