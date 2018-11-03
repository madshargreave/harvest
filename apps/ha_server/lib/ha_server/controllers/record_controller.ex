defmodule HaServer.RecordController do
  use HaServer, :controller
  alias HaStore.Records

  action_fallback HaServer.FallbackController

  def index(conn, %{"table_id" => table_id}) do
    records = Records.list_records(table_id)
    render(conn, "index.json", records: records)
  end

end
