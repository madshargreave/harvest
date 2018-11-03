defmodule HaStore.Records.RecordService do
  @moduledoc """
  Records service
  """
  alias HaStore.Records
  alias HaStore.Records.Store.DefaultImpl
  alias HaStore.Records.{
    Record,
    Recordstore
  }

  @store Application.get_env(:ha_store, :record_store_impl) || DefaultImpl

  @doc """
  Saves a list of records
  """
  @spec save([map]) :: {:ok, Record.t} | {:error, InvalidChangesetError.t}
  def save(records_attrs \\ []) do
    changesets = for attrs <- records_attrs, do: Record.save_changeset(attrs)
    @store.save_all(changesets)
  end

end
