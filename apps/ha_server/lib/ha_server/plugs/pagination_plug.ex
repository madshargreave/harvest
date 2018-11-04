defmodule HaServer.Plugs.PaginationPlug do
  @moduledoc """
  Parses parameter based pagination data
  """
  import Plug.Conn
  alias HaSupport.Pagination

  @fields ~w(limit)

  def init(default) do
    default
  end

  def call(conn, _default) do
    limit = conn.params |> Map.get("limit", "10") |> String.to_integer
    pagination = %Pagination{limit: limit}

    conn
    |> assign(:pagination, pagination)
  end

end
