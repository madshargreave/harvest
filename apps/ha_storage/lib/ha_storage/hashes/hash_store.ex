defmodule HaStorage.Hashes.HashStore do
  @moduledoc """
  Module behaviour for document-based stores
  """
  alias HaStorage.Hashes.{Hash, InsertMutation, UpdateMutation, DeleteMutation}
  alias HaStorage.Hashes.HashStore.Postgres, as: PostgresStore

  @type hash :: Hash.t
  @type hashes :: [hash]
  @type diff :: InsertMutation.t | UpdateMutation.t | DeleteMutation.t
  @type diffs :: [diff]

  @adapter Application.get_env(:ha_storage, :document_store_adapter) || PostgresStore

  def child_spec(opts \\ []) do
    %{
      id: __MODULE__,
      start: {@adapter, :start_link, [opts]}
    }
  end

  @doc """
  Retrieve a list of records by ID
  """
  @callback get(HaStorage.record_ids) :: {:ok, hashes} | {:error, Atom.t}
  defdelegate get(ids), to: @adapter

  @doc """
  Saves records into table
  """
  @callback put(hashes) :: {:ok, hashes} | {:error, Atom.t}
  defdelegate put(hashes), to: @adapter

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour HaStorage.DocumentStore
    end
  end

end
