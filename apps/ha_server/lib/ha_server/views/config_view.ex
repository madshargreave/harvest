defmodule HaServer.ConfigView do
  use HaServer, :view
  alias HaServer.ConfigView

  def render("index.json", %{config: config}) do
    %{data: render_one(config, ConfigView, "config.json")}
  end

  def render("config.json", %{config: config}) do
    config
  end

end
