defmodule HaCore.Logs do
  @moduledoc """
  The Accounts context.
  """
  alias HaCore.Logs.LogService
  alias HaCore.Logs.Store.DefaultImpl

  @store Application.get_env(:ha_core, :log_store_impl) || DefaultImpl

  defdelegate list_logs(job_id, pagination), to: @store, as: :list
  defdelegate capture_logs(logs), to: LogService, as: :capture

end
