defmodule HaServer.LogController do
  use HaServer, :controller

  alias HaCore.Logs
  alias HaCore.Logs.Log

  action_fallback HaServer.FallbackController

  swagger_path :index do
    get "/jobs/{job_id}/logs"
    description "List job logs"
    tag "Logs"
    parameter :job_id, :path, :string, "Table ID", required: true
    paging
    operation_id "list_logs"
    response 200, "Success", Schema.ref(:JobListResponse)
  end

  def index(conn, params) do
    page = Records.list_records(conn.assigns.user, params.job_id, conn.assigns.pagination)
    render(conn, "index.json", records: page.entries, paging: page.metadata)
  end

  def swagger_definitions do
    %{
      Log: Log.__swagger__(:single),
      Logs: Log.__swagger__(:list),
      LogListResponse: swagger_schema do
        type :object
        properties do
          data Schema.ref(:Logs), "", required: true
          paging Schema.ref(:Paging), "", required: true
        end
      end,
    }
  end

end
