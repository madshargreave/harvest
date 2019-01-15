defmodule HaStorage.Records.RecordStore do
  @moduledoc false
  alias HaStorage.Records
  alias HaStorage.Records.Record
  alias HaStorage.Records.S3Store

  @adapter Application.get_env(:ha_storage, :record_store_impl) || S3Store

  @doc """
  Delegates to storage layer based on table and saves records
  """
  @callback search(HaStorage.query) :: {:ok, HaStorage.records} | :error
  defdelegate search(query), to: @adapter

  @doc """
  Delegates to storage layer based on table and saves records
  """
  @callback list(HaStorage.table) :: {:ok, Storage.records} | :error
  defdelegate list(table), to: @adapter

  @doc """
  Delegates to storage layer based on table and saves records
  """
  @callback save(HaStorage.table, HaStorage.records) :: {:ok, Integer.t} | :error
  defdelegate save(table, records), to: @adapter

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour HaStorage.Records.RecordStore
    end
  end

end
