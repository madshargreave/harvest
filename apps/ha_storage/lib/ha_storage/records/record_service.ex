defmodule HaStorage.Records.RecordService do
  @moduledoc false
  require Logger

  alias HaStorage.Dispatcher
  alias HaStorage.Records
  alias HaStorage.Records.{Record, RecordStore}
  alias HaStorage.Records.{FileStore, ElasticStore}

  @doc """
  List records in table
  """
  def list(table) do
    ElasticStore.list(table)
  end

  @doc """
  Save records to table
  """
  def save(records) do
    with {:ok, _} <- ElasticStore.save(records) do
      tables =
        records
        |> Enum.map(& &1.table)
        |> Enum.uniq
      Dispatcher.dispatch(%{
        type: :table_updates,
        ids: tables
      })
    end
  end

  @doc """
  Search records to table
  """
  def search(query) do
    ElasticStore.search(query)
  end

end
