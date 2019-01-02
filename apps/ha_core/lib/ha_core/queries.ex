defmodule HaCore.Queries do
  @moduledoc """
  The Queries context.
  """
  alias HaCore.Queries.{
    Query,
    QueryStore,
    QueryService
  }

  defdelegate get_latest_queries(user, pagination), to: QueryStore
  defdelegate get_saved_queries(user, pagination), to: QueryStore
  defdelegate get_saved_query!(user, id), to: QueryStore
  defdelegate save_query(user, command), to: QueryService, as: :save
  defdelegate delete_query(user, command), to: QueryService, as: :delete

end
