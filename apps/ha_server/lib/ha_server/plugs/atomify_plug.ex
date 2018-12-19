defmodule HaServer.Plugs.AtomifyPlug do
  @moduledoc """
  Parses parameter based pagination data
  """
  import Plug.Conn
  require Logger

  def init(default) do
    default
  end

  def call(conn, _default) do
    params = AtomicMap.convert(conn.params, %{safe: true})
    %{conn | params: params}
  rescue
    exception ->
      Logger.error "Unable to parse params: #{inspect conn.params}"
  end

end
