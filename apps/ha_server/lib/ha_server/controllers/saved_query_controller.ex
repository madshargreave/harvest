defmodule HaServer.SavedQueryController do
  use HaServer, :controller

  alias HaCore.Queries
  alias HaCore.Queries.QueryCommands

  action_fallback HaServer.FallbackController

  swagger_path :index do
    get "/saved_queries"
    description "List saved user queries"
    tag "Saved Queries"
    paging
    operation_id "list_saved_queries"
    response 200, "Success", Schema.ref(:QueryListResponse)
  end

  def index(conn, _params) do
    page = Queries.get_saved_queries(conn.assigns.user, conn.assigns.pagination)
    render(conn, "index.json", saved_queries: page.entries, paging: page.metadata)
  end

  swagger_path :create do
    post "/saved_queries"
    description "Save query"
    tag "Saved Queries"
    parameters do
      query :body, Schema.ref(:SaveQueryCommand), "Query attributes"
    end
    operation_id "save_query"
    response 200, "Success", Schema.ref(:QuerySingleResponse)
    response 422, "Invalid parameters", Schema.ref(:Query)
  end

  def create(conn, params) do
    params = struct(QueryCommands.SaveQueryCommand, params)
    with {:ok, saved_query} <- Queries.save_query(conn.assigns.user, params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", saved_query_path(conn, :show, saved_query))
      |> render("show.json", saved_query: saved_query)
    end
  end

  swagger_path :destroy do
    delete "/saved_queries/{query_id}"
    description "Delete saved query"
    tag "Saved Queries"
    parameter :query_id, :path, :string, "Query ID", required: true
    operation_id "delete_query"
    response 200, "Success", Schema.ref(:QuerySingleResponse)
    response 422, "Invalid parameters", Schema.ref(:Query)
  end

  def destroy(conn, params) do
    command = struct(QueryCommands.DeleteQueryCommand, params)
    with {:ok, saved_query} <- Queries.delete_query(conn.assigns.user, command) do
      conn
      |> put_status(:accepted)
      |> put_resp_header("location", job_path(conn, :show, saved_query))
      |> render("show.json", saved_query: saved_query)
    end
  end

  def swagger_definitions do
    %{
      SaveQueryCommand: QueryCommands.SaveQueryCommand.__swagger__(:single),
      DeleteQueryCommand: QueryCommands.DeleteQueryCommand.__swagger__(:single)
    }
  end

end
