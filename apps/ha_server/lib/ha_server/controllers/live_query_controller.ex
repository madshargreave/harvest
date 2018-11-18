defmodule HaServer.LiveQueryController do
  use HaServer, :controller
  alias HaCore.LiveQueries

  def index(conn, params) do
    page = LiveQueries.list_queries(conn.assigns.user, conn.assigns.pagination) |> IO.inspect
    render(conn, "index.json", saved_queries: page.entries, paging: page.metadata)
  end

  def show(conn, %{"id" => id}) do
    live_query = LiveQueries.get_query!(conn.assigns.user, id)
    render(conn, "show.json", live_query: live_query)
  end

  def create(conn, %{"data" => query_params}) do
    with {:ok, live_query} <- LiveQueries.register_query(conn.assigns.user, query_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", query_path(conn, :show, live_query))
      |> render("show.json", live_query: live_query)
    end
  end

end
