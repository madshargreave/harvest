defmodule HaCore.Queries do
  @moduledoc """
  The Queries context.
  """
  alias HaCore.Queries.{
    Query,
    QueryStore,
    QueryService,
    QueryValidator
  }

  defdelegate get_latest_queries(user, pagination), to: QueryStore
  defdelegate get_saved_queries(user, pagination), to: QueryStore
  defdelegate get_saved_query!(user, id), to: QueryStore
  defdelegate stream_scheduled_queries(callback), to: QueryStore
  defdelegate save_query(user, command), to: QueryService, as: :save
  defdelegate delete_query(user, command), to: QueryService, as: :delete
  defdelegate resolve_query(user, query), to: HaCore.Queries.QueryValidator, as: :resolve

end
