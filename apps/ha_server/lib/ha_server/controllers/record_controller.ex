defmodule HaServer.RecordController do
  use HaServer, :controller

  alias HaStore.Records
  alias HaCore.Queries

  action_fallback HaServer.FallbackController

  def index(conn, %{"table_id" => table_id}) do
    records = Records.list_table_records(table_id)
    render(conn, "index.json", records: records)
  end

  def index(conn, %{"job_id" => job_id}) do
    page = Records.list_job_records(job_id, conn.assigns.pagination)
    render(conn, "index.json", records: page.entries, paging: page.metadata)
  end

  def index(conn, %{"live_query_id" => live_query_id}) do
    query = Queries.get_query!(conn.assigns.user, live_query_id)
    records = Records.list_query_records(query.name, conn.assigns.pagination)
    render(conn, "index.json", records: records, paging: %{})
  end

end
