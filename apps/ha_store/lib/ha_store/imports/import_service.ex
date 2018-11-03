defmodule HaStore.Imports.ImportService do
  @moduledoc """
  Imports service
  """
  alias HaStore.Dispatcher
  alias HaStore.Imports
  alias HaStore.Imports.Store.DefaultImpl
  alias HaStore.Imports.{
    Import,
    Importstore
  }

  @store Application.get_env(:ha_store, :import_store_impl) || DefaultImpl

  @doc """
  Creates a new batch import of table records
  """
  @spec create(map) :: {:ok, Import.t} | {:error, InvalidChangesetError.t}
  def create(attrs \\ %{}) do
    changeset = Import.create_changeset(attrs)
    @store.save(changeset)
  end

end
