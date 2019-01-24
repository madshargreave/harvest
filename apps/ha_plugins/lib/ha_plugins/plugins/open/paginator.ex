defmodule HaPlugins.OpenPlugin.Paginator do
  @moduledoc """
  Source plugin that sends of remote HTTP requests and returns results
  """
  alias HaPlugins.OpenPlugin.Config

  def paginate(response, url, %Config{generator: generator}) when is_binary(generator) do
    parsed = Floki.parse(response.body)
    path =
      Floki.find(parsed, generator)
      |> Floki.attribute("href")
    if path do
      next_url =
        url
        |> Path.join(path)
        |> String.replace(~r/\/$/, "")
      {:ok, parsed, next_url}
    else
      {:ok, nil}
    end
  end

end
