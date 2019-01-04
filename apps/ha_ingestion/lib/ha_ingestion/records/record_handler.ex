defmodule HaIngestion.Records.RecordHandler do
  @moduledoc false
  use GenConsumer, otp_app: :ha_ingestion

  alias HaStorage.Tables.Table
  alias HaStorage.Records.Record

  @impl true
  def handle_event(%{
    type: :records_created,
    table_id: table_id,
    temporary: temporary,
    records: records
  } = event) do
    records =
      for %{key: key, value: value} <- records do
        %Record{key: key, table: table_id, value: value}
      end

    table = %Table{id: table_id, temporary: temporary}
    HaStorage.save(table, records)
    :ok
  end

  @impl true
  def handle_event(_) do
    :ok
  end

end
