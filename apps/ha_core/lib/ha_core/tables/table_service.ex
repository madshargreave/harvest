defmodule HaCore.Tables.TableService do
  @moduledoc """
  Tables service
  """
  alias HaCore.Tables.Store.DefaultImpl
  alias HaCore.Tables.Table
  alias HaCore.Tables.Commands.{
    SaveTableCommand,
  }

  @store Application.get_env(:ha_core, :table_store_impl) || DefaultImpl

  @doc """
  Saves table
  """
  @spec save(HaCore.context, SaveTableCommand.t) :: {:ok, Table.t} | {:error, InvalidChangesetError.t}
  def save(user, %SaveTableCommand{job_id: job_id} = command) when not is_nil(job_id) do
    table = @store.get_by_job!(user, job_id)
    changeset = Table.save_changeset(table, command)
    @store.save(user, changeset)
  end

end
