defmodule HaStorage do
  @moduledoc """
  Data storage
  """
  alias Exd.AST.Query
  alias HaStorage.Records.{Record, RecordService, RecordStore}
  alias HaStorage.Tables.Table

  @type query :: Query.t
  @type table :: Table.t
  @type table_id :: String.t
  @type record :: Record.t
  @type records :: [record]

  @doc """
  Saves records into table
  """
  @spec save(table, records) :: {:ok, Integer.t} | {:error, Atom.t}
  defdelegate save(table, records), to: RecordService

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
