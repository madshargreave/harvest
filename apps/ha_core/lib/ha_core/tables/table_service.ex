defmodule HaCore.Tables.TableService do
  @moduledoc """
  Tables service
  """
  alias HaCore.Tables.Store.DefaultImpl
  alias HaCore.Tables.Table
  alias HaCore.Tables.Commands.{
    SaveTableCommand,
    DeleteTableCommand
  }

  @store Application.get_env(:ha_core, :table_store_impl) || DefaultImpl

  @doc """
  Saves table
  """
  @spec save(HaCore.context, SaveTableCommand.t) :: {:ok, Table.t} | {:error, InvalidChangesetError.t}
  def save(user, %SaveTableCommand{table_id: table_id} = command) when not is_nil(table_id) do
    table = @store.get_by_user!(user, table_id)
    changeset = Table.save_changeset(table, command)
    @store.save(user, changeset)
  end

  @doc """
  Deletes an existing table
  """
  @spec delete(HaCore.context, DeleteTableCommand.t) :: {:ok, Table.t} | {:error, InvalidChangesetError.t}
  def delete(user, command) do
    table = @store.get_by_user!(user, command.table_id)
    changeset = Table.delete_changeset(table, command)
    @store.save(user, changeset)
  end


end
