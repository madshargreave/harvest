defmodule HaServer.QueryController do
  use HaServer, :controller

  action_fallback HaServer.FallbackController

  def create(conn, %{"data" => query_params}) do
    user = %HaCore.Accounts.User{id: "abc"}
    with {:ok, query} <- HaCore.Queries.run_query(user, query_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", query_path(conn, :show, query))
      |> render("show.json", query: query)
    end
  end

end
