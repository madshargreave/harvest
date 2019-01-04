defmodule HaStorage.Records.RecordService do
  @moduledoc false
  alias HaStorage.Tables.Table
  alias HaStorage.Records
  alias HaStorage.Records.{Record, RecordStore}
  alias HaStorage.Records.{FileStore, ElasticStore}

  @doc """
  List records in table
  """
  @callback list(HaStorage.table) :: {:ok, Integer.t} | :error
  def list(%Table{temporary: true} = table) do
    FileStore.list(table)
  end

  def list(%Table{temporary: false} = table) do
    ElasticStore.list(table)
  end

  @doc """
  Save records to table
  """
  @callback save(HaStorage.table, HaStorage.records) :: {:ok, Integer.t} | :error
  def save(%Table{temporary: true} = table, records) do
    FileStore.save(table, records)
  end

  def save(%Table{temporary: false} = table, records) do
    ElasticStore.save(table, records)
  end

  @doc """
  Search records to table
  """
  @callback search(HaCore.query) :: {:ok, any} | :error
  def search(query) do
    ElasticStore.search(query)
  end

end
