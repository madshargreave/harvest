defmodule HaAgent.MixProject do
  use Mix.Project

  def project do
    [
      app: :ha_agent,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {HaAgent, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:aws_lambda_elixir_runtime, "~> 0.1.0"},
      # {:ha_core, in_umbrella: true}
      # {:ha_plugins, in_umbrella: true},
      # {:ha_support, in_umbrella: true}
      # {:poolboy, "~> 1.5.1"},
      # {:libcluster, "~> 3.0.1"}
    ]
  end
end
