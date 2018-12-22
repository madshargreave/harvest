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
  @callback get_user_table_records(HaCore.user, binary()) :: [Record.t]

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour HaCore.Record.RecordStore
    end
  end

end
