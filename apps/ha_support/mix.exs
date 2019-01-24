defmodule HASupport.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ha_support,
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
      {:exd, "~> 0.2.1", override: true},
      {:exd_streams, "~> 0.0.4"},
      {:exd_plugin_html, "~> 0.1.1"},
      {:exd_codegen_elastic, "~> 0.1.0"},
      {:gen_dispatcher, ">= 0.0.0"},
      {:gen_consumer, ">= 0.2.6"},
      {:gen_buffer, "~> 0.1.0"},
      {:swagger_ecto, "~> 0.2.2"},
      {:ecto, "~> 2.2", override: true},
      {:postgrex, "~> 0.13.0"},
      {:redix, ">= 0.0.0"},
      {:redix_stream, "~> 0.1.3"},
      {:httpoison, "~> 1.4", override: true},
      {:poison, "~> 3.1.0"},
      {:atomic_map, "~> 0.8"},
      {:elixir_uuid, "~> 1.2"}
    ]
  end

end
