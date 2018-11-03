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
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ha_core, in_umbrella: true},
      {:ha_dsl, in_umbrella: true},
      {:ha_support, in_umbrella: true}
    ]
  end
end
