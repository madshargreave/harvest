defmodule HaCore.Logs.LogService do
  @moduledoc """
  Logs service
  """
  alias HaCore.Logs.Store.DefaultImpl
  alias HaCore.Logs.Log
  alias HaCore.Commands.CreateLogCommand

  @store Application.get_env(:ha_core, :log_store_impl) || DefaultImpl

  @doc """
  Creates a new job
  """
  @spec capture([Log.t]) :: {:ok, Integer.t} | {:error, InvalidChangesetError.t}
  def capture(logs) do
    @store.save_all(logs)
  end

end
