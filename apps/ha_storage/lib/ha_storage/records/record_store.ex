defmodule HaStorage.Records.RecordStore do
  @moduledoc false
  alias HaStorage.Records
  alias HaStorage.Records.Record

  @doc """
  Delegates to storage layer based on table and saves records
  """
  @callback search(HaStorage.query) :: {:ok, HaStorage.records} | :error

  @doc """
  Delegates to storage layer based on table and saves records
  """
  @callback list(HaStorage.table) :: {:ok, Storage.records} | :error

  @doc """
  Delegates to storage layer based on table and saves records
  """
  @callback save(HaStorage.table, HaStorage.records) :: {:ok, Integer.t} | :error

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour HaStorage.Records.RecordStore
    end
  end

end
