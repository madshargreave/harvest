defmodule Harvest.Server.Queries do
  @moduledoc """
  The queries context.
  """
  alias Harvest.Server.Queries.Store, as: QueryStore

  defdelegate count_queries, to: QueryStore, as: :count
  defdelegate list_queries, to: QueryStore, as: :list
  defdelegate get_query!(id), to: QueryStore, as: :get!
  defdelegate create_query(attrs), to: QueryStore, as: :create
  defdelegate update_query(user, attrs), to: QueryStore, as: :update
  defdelegate delete_query(user), to: QueryStore, as: :delete

end

