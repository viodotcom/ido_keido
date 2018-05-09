use Mix.Config

config :ido_keido, IdoKeidoWeb.Endpoint,
  http: [port: 4004],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

# Do not include metadata nor timestamps in development logs.
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development.
config :phoenix, :stacktrace_depth, 20
