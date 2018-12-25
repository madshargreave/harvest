defmodule HaCore.Queries do
  @moduledoc """
  The Accounts context.
  """
  alias HaCore.Queries.QueryService
  alias HaCore.Queries.Store.DefaultImpl

  @store Application.get_env(:ha_core, :query_store_impl) || DefaultImpl

  defdelegate list_latest_queries(user, pagination), to: @store, as: :get_latest_user_queries

end
