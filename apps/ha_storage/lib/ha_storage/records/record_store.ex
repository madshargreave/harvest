defmodule HaStorage.Records.RecordStore do
  @moduledoc false
  alias HaSupport.Pagination
  alias HaStorage.Records
  alias HaStorage.Records.Record
  alias HaStorage.Records.DynamoStore

  @adapter Application.get_env(:ha_storage, :record_store_impl) || DynamoStore

  @doc """
  Delegates to storage layer based on table and saves records
  """
  @callback start_link(Keyword.t) :: GenServer.on_start
  defdelegate start_link(opts \\ []), to: @adapter

  @doc """
  Delegates to storage layer based on table and saves records
  """
  @callback search(HaStorage.query) :: {:ok, HaStorage.records} | :error
  defdelegate search(query), to: @adapter

  @doc """
  Delegates to storage layer based on table and saves records
  """
  @callback list(HaStorage.table, Pagination.t) :: {:ok, Storage.records} | :error
  defdelegate list(table, pagination), to: @adapter

  @doc """
  Delegates to storage layer based on table and saves records
  """
  @callback save(HaStorage.table, HaStorage.records) :: {:ok, Integer.t} | :error
  defdelegate save(table, records), to: @adapter

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour HaStorage.Records.RecordStore
      def start_link(_opts) do
        :ok
      end
      defoverridable start_link: 1
    end
  end

end
