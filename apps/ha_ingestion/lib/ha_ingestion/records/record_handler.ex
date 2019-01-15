defmodule HaIngestion.Records.RecordHandler do
  @moduledoc false
  use GenConsumer, otp_app: :ha_ingestion

  alias HaStorage.Tables.Table
  alias HaStorage.Records.Record
  alias HaStorage.Hashes.Hash

  @impl true
  def handle_event(%{
    type: :records_created,
    table_id: table_id,
    temporary: temporary,
    records: records
  } = event) do
    hashes =
      for %{key: key, value: value} <- records do
        %Hash{key: key, table_id: table_id, value: value}
      end

    HaStorage.save(%Table{id: table_id}, hashes)
    :ok
  end

  @impl true
  def handle_event(_) do
    :ok
  end

end
