use Mix.Config

port = String.to_integer(System.get_env("PORT"))

config :ido_keido, IdoKeidoWeb.Endpoint,
  http: [:inet6, port: port],
  url: [host: "localhost", port: port],
  load_from_system_env: false,
  server: true

config :logger, level: :info
