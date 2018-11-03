defmodule HaCore.Queries.QueryService do
  @moduledoc """
  Jobs service
  """
  alias HaCore.Queries
  alias HaCore.Queries.Store.DefaultImpl
  alias HaCore.Queries.{
    Query,
    QueryStore
  }

  @store Application.get_env(:ha_core, :query_store_impl) || DefaultImpl

  @doc """
  Saves query
  """
  @spec save(HaCore.user, map) :: {:ok, Query.t} | {:error, InvalidChangesetError.t}
  def save(user, attrs \\ %{}) do
    changeset = Query.save_changeset(user, attrs)
    @store.save(changeset)
  end

  @doc """
  Runs a saved query
  """
  @spec run(HaCore.user, map) :: {:ok, Query.t} | {:error, InvalidChangesetError.t}
  def run(user, attrs \\ %{}) do
    changeset = Query.run_changeset(user, attrs)
    @store.save(changeset)
  end

  @doc """
  Deletes a saved query
  """
  @spec delete(HaCore.user, Queries.id) :: {:ok, Query.t} | {:error, InvalidChangesetError.t}
  def delete(user, query_id) do
    query = @store.get!(user, query_id)
    changeset = Query.delete_changeset(user, query)
    @store.save(changeset)
  end

end
