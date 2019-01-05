defmodule HaCore.Queries do
  @moduledoc """
  The Queries context.
  """
  alias HaCore.Queries.{
    Query,
    QueryPlan,
    QueryStore,
    QueryService,
    QueryValidator
  }

  @type plan :: QueryPlan.t

  defdelegate get_latest_queries(user, pagination), to: QueryStore
  defdelegate get_saved_queries(user, pagination), to: QueryStore
  defdelegate get_saved_query!(user, id), to: QueryStore
  defdelegate stream_scheduled_queries(callback), to: QueryStore
  defdelegate save_query(user, command), to: QueryService, as: :save
  defdelegate delete_query(user, command), to: QueryService, as: :delete
  defdelegate resolve_query(user, query), to: QueryValidator, as: :resolve

end
