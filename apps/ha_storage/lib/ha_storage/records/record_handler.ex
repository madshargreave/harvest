defmodule HaStorage.Records.RecordHandler do
  @moduledoc false
  require Logger
  use GenConsumer, otp_app: :ha_storage

  alias HaStorage.Tables.Table
  alias HaStorage.Records.{Record, RecordWriter}
  alias HaStorage.Hashes.{
    InsertMutation,
    UpdateMutation,
    DeleteMutation
  }

  @impl true
  def handle_event(%InsertMutation{
    key: key,
    value: value,
    table_id: table_id,
    ts: ts
  }) do
    spawn_link fn ->
      RecordWriter.add(
        %Record{key: key, table: table_id, value: value, ts: ts }
      )
    end
    :ok
  end

  @impl true
  def handle_event(%UpdateMutation{
    key: key,
    new: value,
    table_id: table_id,
    ts: ts
  }) do
    spawn_link fn ->
      RecordWriter.add(
        %Record{key: key, table: table_id, value: value, ts: ts }
      )
    end
    :ok
  end

  @impl true
  def handle_event(_) do
    :ok
  end

end
