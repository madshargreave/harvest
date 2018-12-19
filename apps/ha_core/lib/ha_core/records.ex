defmodule HaCore.Records do
  @moduledoc """
  The Accounts context.
  """
  alias HaCore.Records.RecordService
  alias HaCore.Records.Store.DefaultImpl

  @store Application.get_env(:ha_core, :record_store_impl) || DefaultImpl

  defdelegate list_records(user, table_id, pagination), to: @store, as: :list

end
