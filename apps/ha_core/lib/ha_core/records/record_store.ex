defmodule HaCore.Records.RecordStore do
  @moduledoc """
  Account store
  """
  alias Ecto.Changeset

  alias HaCore.Records
  alias HaCore.Records.Record

  @adapter Application.get_env(:ha_core, :records_store_impl) || HaCore.Records.Store.DefaultImpl

  @doc """
  Returns the list of queries.
  """
  @callback get_user_table_records(HaCore.user, binary(), any) :: [Record.t]
  defdelegate get_user_table_records(user, table_id, pagination), to: @adapter

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour HaCore.Record.RecordStore
    end
  end

end
