defmodule HaServer.Plugs.SnakeCasePlug do
  @moduledoc """
  Parses parameter based pagination data
  """
  import Plug.Conn
  require Logger

  def init(default) do
    default
  end

  def call(conn, _default) do
    params = ProperCase.to_snake_case(conn.params)
    body_params = ProperCase.to_snake_case(conn.body_params)
    %{conn | params: params, body_params: body_params}
  end

end
