use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ido_keido, IdoKeidoWeb.Endpoint,
  http: [port: 4001],
  server: false

config :logger, level: :warn

config :ido_keido, :injections,
  geolocation: IdoKeido.GeolocationMock,
  repo: IdoKeido.RepoMock

config :geolix, databases: []
