defmodule HaServer.Plugs.AtomifyPlug do
  @moduledoc """
  Parses parameter based pagination data
  """
  import Plug.Conn

  def init(default) do
    default
  end

  def call(conn, _default) do
    params = AtomicMap.convert(conn.params, %{safe: true})
    %{conn | params: params}
  end

end
