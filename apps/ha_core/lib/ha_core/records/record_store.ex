defmodule HaCore.Records.RecordStore do
  @moduledoc """
  Account store
  """
  alias Ecto.Changeset

  alias HaCore.Records
  alias HaCore.Records.Record

  @doc """
  Returns the list of queries.
  """
  @callback list(HaCore.user) :: {:ok, [Table.t]}

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour HaCore.Tables.TableStore
    end
  end

end
