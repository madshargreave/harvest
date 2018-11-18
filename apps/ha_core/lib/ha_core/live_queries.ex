defmodule HaCore.LiveQueries do
  @moduledoc """
  The queries context.
  """
  alias HaCore.Accounts
  alias HaCore.LiveQueries.{
    LiveQuery,
    LiveQueryService
  }

  @type query :: LiveQuery.t
  @type id :: binary

  defdelegate list_queries(user, pagination), to: LiveQueryService, as: :list
  defdelegate get_query!(user, id), to: LiveQueryService, as: :get!
  defdelegate register_query(user, attrs), to: LiveQueryService, as: :register
  defdelegate pause_query(user, attrs), to: LiveQueryService, as: :pause
  defdelegate resume_query(user, attrs), to: LiveQueryService, as: :resume
  defdelegate delete_query(user, attrs), to: LiveQueryService, as: :delete

end

