defmodule HaServer.QueryController do
  use HaServer, :controller
  alias HaCore.Queries

  action_fallback HaServer.FallbackController

  swagger_path :index do
    get "/queries"
    description "List latest queries"
    tag "Queries"
    paging
    operation_id "list_latest_queries"
    response 200, "Success", Schema.ref(:QueryListResponse)
  end

  def index(conn, params) do
    page = Queries.list_latest_queries(conn.assigns.user, conn.assigns.pagination)
    render(conn, "index.json", queries: page.entries, paging: page.metadata)
  end

  def swagger_definitions do
    %{
      Query: Queries.Query.__swagger__(:single),
      Queries: Queries.Query.__swagger__(:list),
      QueryListResponse: swagger_schema do
        type :object
        properties do
          data Schema.ref(:Queries), "", required: true
          paging Schema.ref(:Paging), "", required: true
        end
      end,
    }
  end

end
