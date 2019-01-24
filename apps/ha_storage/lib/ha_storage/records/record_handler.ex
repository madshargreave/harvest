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
        %Record{id: key, table_id: table_id, value: value, inserted_at: ts}
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
        %Record{id: key, table_id: table_id, value: value, inserted_at: ts}
      )
    end
    :ok
  end

  @impl true
  def handle_event(_) do
    :ok
  end

end
