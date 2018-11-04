defmodule HaServer.QueryController do
  use HaServer, :controller

  @user %HaCore.Accounts.User{id: "d5660ce8-6279-45ff-abcd-616f84fc51fe"}

  action_fallback HaServer.FallbackController

  def create(conn, %{"data" => query_params}) do
    with {:ok, query} <- HaCore.Queries.run_query(@user, query_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", query_path(conn, :show, query))
      |> render("show.json", query: query)
    end
  end

end
