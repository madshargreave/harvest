defmodule HaPlugins.OpenPlugin.Client do
  @moduledoc false

  def request(url, opts) do
    HTTPoison.get(url)
  end

end
