defmodule HaServer.RecordController do
  use HaServer, :controller
  alias HaStore.Records

  action_fallback HaServer.FallbackController

  def index(conn, %{"table_id" => table_id}) do
    records = Records.list_table_records(table_id)
    render(conn, "index.json", records: records)
  end

  def index(conn, %{"job_id" => job_id}) do
    page = Records.list_job_records(job_id, conn.assigns.pagination)
    render(conn, "index.json", records: page.entries, paging: page.metadata)
  end

end
