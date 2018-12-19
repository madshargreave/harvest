defmodule HaCore.Logs.LogService do
  @moduledoc """
  Logs service
  """
  alias HaCore.Logs.Store.DefaultImpl
  alias HaCore.Logs.Log
  alias HaCore.Logs.Events.LogCreated

  @store Application.get_env(:ha_core, :log_store_impl) || DefaultImpl

  @doc """
  Creates a new job
  """
  @spec capture(HaCore.context, [Log.t]) :: {:ok, Integer.t} | {:error, InvalidChangesetError.t}
  def capture(context, logs) do
    result = @store.save_all(logs)
    for log <- logs do
      HaCore.Dispatcher.dispatch(
        LogCreated.make(context, log)
      )
    end
    result
  end

end
