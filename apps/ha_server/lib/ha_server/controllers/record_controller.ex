defmodule HaServer.RecordController do
  use HaServer, :controller
  alias HaCore.Records

  action_fallback HaServer.FallbackController

  swagger_path :index do
    get "/tables/{table_id}/records"
    description "List records"
    tag "Records"
    parameter :table_id, :path, :string, "Table ID", required: true
    paging
    operation_id "list_records"
    response 200, "Success", Schema.ref(:RecordListResponse)
  end

  def index(conn, params) do
    page = Records.list_records(conn.assigns.user, params.table_id, conn.assigns.pagination)
    render(conn, "index.json", records: page.entries, paging: page.metadata)
  end

  def swagger_definitions do
    %{
      Record: swagger_schema do
        title "test"
      end,
      Records: swagger_schema do
        title "test"
        type :array
        items Schema.ref(:Record)
      end,
      RecordListResponse: swagger_schema do
        type :object
        properties do
          data Schema.ref(:Records), "", required: true
          paging Schema.ref(:Paging), "", required: true
        end
      end,
    }
  end

end
