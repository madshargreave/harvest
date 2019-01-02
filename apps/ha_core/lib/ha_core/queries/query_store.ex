defmodule HaCore.Queries.QueryStore do
  @moduledoc """
  Account store
  """
  alias HaCore.Queries
  alias HaCore.Queries.Query
  alias HaCore.Queries.Store.DefaultImpl

  @adapter Application.get_env(:ha_core, :query_store_impl) || DefaultImpl

  @doc """
  Returns the list of queries.
  """
  @callback get_latest_queries(HaCore.user, any()) :: [Query.t]
  defdelegate get_latest_queries(user, pagination), to: @adapter

  @doc """
  Returns the list of queries.
  """
  @callback get_saved_queries(HaCore.user, any()) :: [Query.t]
  defdelegate get_saved_queries(user, pagination), to: @adapter

  @doc """
  Returns the list of queries.
  """
  @callback get_saved_query!(HaCore.user, String.t) :: [Query.t]
  defdelegate get_saved_query!(user, id), to: @adapter

  @doc """
  Returns a stream of saved queries
  """
  @callback stream_scheduled_queries(function) :: [Query.t]
  defdelegate stream_scheduled_queries(callback), to: @adapter

  @doc """
  Gets a single query.
  """
  @callback get!(HaCore.user, String.t) :: Query.t
  defdelegate get!(user, id), to: @adapter

  @doc """
  Saves a query changeset
  """
  @callback save(HaCore.context, Changeset.t) :: {:ok, Query.t}
  defdelegate save(context, changeset), to: @adapter

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour HaCore.Queries.QueryStore
    end
  end

end
