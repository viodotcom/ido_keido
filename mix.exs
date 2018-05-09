defmodule IdoKeido.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ido_keido,
      version: "0.0.1",
      elixir: "~> 1.8.1",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      deps: deps(),
      description: description(),
      dialyzer: dialyzer(),
      docs: docs()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {IdoKeido.Application, []},
      extra_applications: [
        :cachex,
        :geolix,
        :logger,
        :runtime_tools
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # Phoenix deps
      {:phoenix, "~> 1.4.0"},
      {:plug_cowboy, "~> 2.0"},
      {:plug, "~> 1.7"},
      {:gettext, "~> 0.16"},

      # Application deps
      {:cachex, "~> 3.1"},
      {:distillery, "~> 2.0"},
      {:geolix, "~> 0.17"},
      {:jason, "~> 1.1"},
      {:typed_struct, "~> 0.1.4", runtime: false},

      # Dev and test
      {:credo, "~> 1.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.4", only: :dev, runtime: false},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:excoveralls, "~> 0.10", only: :test},
      {:mox, "~> 0.5", only: :test}
    ]
  end

  defp description do
    """
    Geolocation Service API to determine city, location, country and continent from given IP addresses.
    """
  end

  defp dialyzer do
    [
      ignore_warnings: "dialyzer.ignore",
      # https://github.com/jeremyjh/dialyxir/wiki/Phoenix-Dialyxir-Quickstart
      plt_add_deps: :transitive,
      plt_add_apps: [:mix]
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"],
      source_url: "https://github.com/FindHotel/ido_keido",
      groups_for_modules: [
        "API ": ~r/^IdoKeidoWeb*/,
        "Geolocation ": ~r/^IdoKeido.Geolocation*/
      ]
    ]
  end
end
