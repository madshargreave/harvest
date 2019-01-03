defmodule HaIngestion.Records.RecordHandler do
  @moduledoc false
  use GenConsumer, otp_app: :ha_ingestion

  alias HaIngestion.Records.{Record, RecordWriter}

  @impl true
  def handle_event(%{
    type: :records_created,
    table_id: table_id,
    records: records
  } = event) do
    records =
      for %{key: key, value: value} <- records do
        %Record{key: key, table: table_id, value: value}
      end
    spawn_link(fn -> RecordWriter.add(records) end)
    :ok
  end

  @impl true
  def handle_event(_) do
    :ok
  end

end
