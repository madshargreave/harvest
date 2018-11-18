defmodule HaStore.Records.RecordStore do
  @moduledoc """
  Account store
  """
  alias Ecto.Changeset

  alias HaStore.Records
  alias HaStore.Records.Record

  @doc """
  Returns number of queries.
  """
  @callback count(Records.table_id) :: {:ok, integer}

  @doc """
  Returns the list of queries.
  """
  @callback get_by_query(Records.query_id, integer) :: {:ok, [Record.t]}

  @doc """
  Returns the list of queries.
  """
  @callback get_by_table(Records.table_id) :: {:ok, [Record.t]}

  @doc """
  Returns the list of queries.
  """
  @callback get_by_job(Records.job_id) :: {:ok, [Record.t]}

  @doc """
  Saves a job changeset
  """
  @callback save_all([Changeset.t]) :: {:ok, integer()}

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour HaStore.Records.RecordStore
    end
  end

end
