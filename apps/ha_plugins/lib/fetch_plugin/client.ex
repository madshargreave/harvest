defmodule HaPlugins.FetchPlugin.Client do
  @moduledoc false
  defstruct [:concurrency, :retries, :timeout]

  def new(opts) do
    %__MODULE__{}
  end

  def get(client, url) do
    HTTPoison.get(url)
  end

end
