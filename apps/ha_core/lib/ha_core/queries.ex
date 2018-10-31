defmodule HaCore.Queries do
  @moduledoc """
  The queries context.
  """
  alias HaCore.Accounts

  alias HaCore.Queries.Store.DefaultImpl, as: DefaultQueryStore
  alias HaCore.Queries.{
    Query,
    QueryService
  }

  @store_impl Application.get_env(:ha_server, :query_store_impl) || DefaultQueryStore

  @type query :: Query.t
  @type id :: binary

  defdelegate count_queries(user), to: @store_impl, as: :count
  defdelegate list_queries(user), to: @store_impl, as: :list
  defdelegate get_query!(user, id), to: @store_impl, as: :get!
  defdelegate save_query(user, attrs), to: QueryService, as: :save
  defdelegate run_query(user, query_id), to: QueryService, as: :run
  defdelegate delete_query(user, query), to: QueryService, as: :delete

end

