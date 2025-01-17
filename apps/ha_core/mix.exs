defmodule HaCore.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ha_core,
      version: "0.0.1",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.8",
      elixirc_paths: elixirc_paths(Mix.env),
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {HaCore.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:ha_support, in_umbrella: true},
      {:ha_storage, in_umbrella: true, runtime: false},
      {:ha_dsl, in_umbrella: true},
      {:cognitex, "~> 0.1.0"},
      {:httpoison, "~> 1.4", override: true},
      {:event_bus, "~> 1.6.0"},
      {:paginator, "~> 0.4.1"},
      {:mox, "~> 0.4", only: :test}
    ]
  end

end
