defmodule HaIngestion.Records.RecordStore do
  @moduledoc """

  """
  alias HaIngestion.Records
  alias HaIngestion.Records.Record
  alias HaIngestion.Records.ElasticStore

  @adapter Application.get_env(:ha_ingestion, :record_store_adapter) || ElasticStore

  @doc """
  Saves a list of records to datastore
  """
  @callback save(Records.records) :: {:ok, integer()} | :error
  defdelegate save(records), to: @adapter

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour HaIngestion.Records.RecordStore
    end
  end

end
