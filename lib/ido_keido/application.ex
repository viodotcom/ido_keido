defmodule IdoKeido.Application do
  @moduledoc false

  use Application
  import Cachex.Spec

  alias IdoKeido.Cache

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      supervisor(IdoKeidoWeb.Endpoint, []),
      # Start your own worker by calling: IdoKeido.Worker.start_link(arg1, arg2, arg3)
      # worker(IdoKeido.Worker, [arg1, arg2, arg3]),

      worker(Cachex, [
        Cache.cache_name(),
        [
          expiration: expiration(default: Cache.default_ttl())
        ]
      ])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: IdoKeido.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    IdoKeidoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
