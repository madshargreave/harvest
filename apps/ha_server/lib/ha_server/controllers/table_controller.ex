defmodule HaServer.TableController do
  use HaServer, :controller

  alias HaCore.Tables
  alias HaCore.Tables.Commands.{DeleteTableCommand, SaveTableCommand}

  action_fallback HaServer.FallbackController

  swagger_path :index do
    get "/tables"
    description "List tables"
    tag "Tables"
    paging
    operation_id "list_tables"
    response 200, "Success", Schema.ref(:TableListResponse)
  end

  def index(conn, params) do
    page = Tables.list_tables(conn.assigns.user, conn.assigns.pagination)
    render(conn, "index.json", tables: page.entries, paging: page.metadata)
  end

  swagger_path :show do
    get "/tables/{id}"
    description "Get table"
    tag "Tables"
    parameter :id, :path, :string, "Table ID", required: true
    operation_id "get_table"
    response 200, "Success", Schema.ref(:TableSingleResponse)
    response 404, "Not found"
  end

  def show(conn, %{id: id}) do
    table = Tables.get_table!(conn.assigns.user, id)
    render(conn, "show.json", table: table)
  end

  swagger_path :create do
    post "/tables"
    description "Create a new table from job results"
    tag "Tables"
    parameters do
      table :body, Schema.ref(:SaveTableCommand), "Table attributes"
    end
    operation_id "save_table"
    response 200, "Success", Schema.ref(:TableSingleResponse)
    response 422, "Invalid parameters", Schema.ref(:Table)
  end

  def create(conn, params) do
    command = struct(SaveTableCommand, params)
    with {:ok, table} <- Tables.save_table(conn.assigns.user, command) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", job_path(conn, :show, table))
      |> render("show.json", table: table)
    end
  end

  swagger_path :destroy do
    delete "/tables/{table_id}"
    description "Delete table"
    tag "Tables"
    parameter :table_id, :path, :string, "Table ID", required: true
    operation_id "delete_table"
    response 200, "Success", Schema.ref(:TableSingleResponse)
    response 422, "Invalid parameters", Schema.ref(:Table)
  end

  def destroy(conn, params) do
    command = struct(DeleteTableCommand, params)
    with {:ok, table} <- Tables.delete_table(conn.assigns.user, command) do
      conn
      |> put_status(:accepted)
      |> put_resp_header("location", job_path(conn, :show, table))
      |> render("show.json", table: table)
    end
  end

  def swagger_definitions do
    %{
      TableSingleResponse: swagger_schema do
        type :object
        properties do
          data Schema.ref(:Table), "", required: true
        end
      end,
      TableListResponse: swagger_schema do
        type :object
        properties do
          data Schema.ref(:Tables), "", required: true
          paging Schema.ref(:Paging), "", required: true
        end
      end,
      SaveTableCommand: SaveTableCommand.__swagger__(:single),
      Table: Tables.Table.__swagger__(:single),
      Tables: Tables.Table.__swagger__(:list)
    }
  end

end
