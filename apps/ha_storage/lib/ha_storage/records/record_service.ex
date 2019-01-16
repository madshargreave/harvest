defmodule HaStorage.Records.RecordService do
  @moduledoc false
  require Logger

  alias HaStorage.Dispatcher
  alias HaStorage.Records
  alias HaStorage.Records.{Record, RecordStore}

  @doc """
  Save records to table
  """
  def save(table, records) do
    with {:ok, _} <- RecordStore.save(table, records) do
      Dispatcher.dispatch(%{
        type: :table_updates,
        ids: [table.id]
      })
    end
  end

end
