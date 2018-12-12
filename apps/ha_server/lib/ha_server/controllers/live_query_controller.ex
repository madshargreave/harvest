defmodule HaServer.StreamController do
  use HaServer, :controller
  alias HaCore.Streams

  def index(conn, params) do
    page = Streams.list_queries(conn.assigns.user, conn.assigns.pagination)
    render(conn, "index.json", saved_queries: page.entries, paging: page.metadata)
  end

  def show(conn, %{"id" => id}) do
    stream = Streams.get_query!(conn.assigns.user, id)
    render(conn, "show.json", stream: stream)
  end

  def create(conn, %{"data" => query_params}) do
    with {:ok, stream} <- Streams.register_query(conn.assigns.user, query_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", query_path(conn, :show, stream))
      |> render("show.json", stream: stream)
    end
  end

end
