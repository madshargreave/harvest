defmodule Harvest.MixProject do
  use Mix.Project

  def project do
    [
      app: :harvest,
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      {:distillery, "~> 2.0"},
      {:mix_test_watch, "~> 0.8", only: :dev, runtime: false}
    ]
  end
end
