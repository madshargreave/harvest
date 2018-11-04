defmodule HaServer.QueryController do
  use HaServer, :controller

  def create(conn, %{"data" => query_params}) do
    with {:ok, query} <- HaCore.Queries.run_query(conn.assigns.user, query_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", query_path(conn, :show, query))
      |> render("show.json", query: query)
    end
  end

end
