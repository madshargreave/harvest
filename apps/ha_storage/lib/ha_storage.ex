defmodule HaStorage do
  @moduledoc """
  Data storage
  """
  alias Exd.AST.Query
  alias HaStorage.Records.{Record, RecordService, RecordStore}
  alias HaStorage.Hashes.{Hash, HashService, HashStore}
  alias HaStorage.Tables.Table

  @type query :: Query.t
  @type table :: Table.t
  @type table_id :: String.t
  @type record_id :: String.t
  @type record_ids :: [record_id]
  @type hash :: Hash.t
  @type hashes :: [hash]
  @type record :: Record.t
  @type records :: [record]

  @doc """
  Retrieve a list of records by ID
  """
  @spec get(record_ids) :: {:ok, Integer.t} | {:error, Atom.t}
  defdelegate get(ids), to: HashStore

  @doc """
  Saves records into table
  """
  @spec save(hashes) :: {:ok, Integer.t} | {:error, Atom.t}
  defdelegate save(hashes), to: HashService

  @doc """
  List records in table
  """
  @spec list(table_id) :: {:ok, Integer.t} | {:error, Atom.t}
  defdelegate list(table_id), to: RecordService

  @doc """
  List records in table
  """
  @spec search(query) :: {:ok, any()} | {:error, Atom.t}
  defdelegate search(query), to: RecordService

end
