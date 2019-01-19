defmodule HaServer.Plugs.AtomifyPlug do
  @moduledoc """
  Parses parameter based pagination data
  """
  require Logger

  def init(default) do
    default
  end

  def call(conn, _default) do
    params = AtomicMap.convert(conn.params, %{safe: true})
    %{conn | params: params}
  rescue
    _exception ->
      Logger.error "Unable to parse params: #{inspect conn.params}"
  end

end
