defmodule HaCore.LiveQueries.LiveQueryService do
  @moduledoc """
  Jobs service
  """
  alias ExCore.DTO.QueryDTO
  alias HaCore.LiveQueries
  alias HaCore.LiveQueries.Store.DefaultImpl
  alias HaCore.LiveQueries.{
    LiveQuery,
    LiveQueryStore
  }

  @store Application.get_env(:ha_core, :live_query_store_impl) || DefaultImpl

  @doc """
  Lists all live queries for user
  """
  @spec list(HaCore.user, HaCore.pagination) :: [QueryDTO.t]
  def list(user, pagination) do
    page = @store.list(user, pagination)
    dto(page)
  end

  @doc """
  Get a single query
  """
  @spec get!(HaCore.user, LiveQueries.id) :: QueryDTO.t
  def get!(user, query_id) do
    query = @store.get!(user, query_id)
    dto(query)
  end

  @doc """
  Registers a live query
  """
  @spec register(HaCore.user, map) :: {:ok, QueryDTO.t} | {:error, InvalidChangesetError.t}
  def register(user, attrs \\ %{}) do
    changeset = LiveQuery.register_changeset(user, attrs)
    result = @store.save(user, changeset)
    dto(result)
  end

  @doc """
  Registers a live query
  """
  @spec pause(HaCore.user, LiveQueries.id) :: {:ok, QueryDTO.t} | {:error, InvalidChangesetError.t}
  def pause(user, live_query_id) do
    live_query = @store.get!(user, live_query_id)
    changeset = LiveQuery.pause_changeset(live_query)
    result = @store.save(user, changeset)
    dto(result)
  end

  @doc """
  Registers a live query
  """
  @spec resume(HaCore.user, LiveQueries.id) :: {:ok, QueryDTO.t} | {:error, InvalidChangesetError.t}
  def resume(user, live_query_id) do
    live_query = @store.get!(user, live_query_id)
    changeset = LiveQuery.resume_changeset(live_query)
    result = @store.save(user, changeset)
    dto(result)
  end

  @doc """
  Deletes a live query
  """
  @spec delete(HaCore.user, LiveQueries.id) :: {:ok, QueryDTO.t} | {:error, InvalidChangesetError.t}
  def delete(user, live_query_id) do
    live_query = @store.get!(user, live_query_id)
    changeset = LiveQuery.delete_changeset(live_query)
    result = @store.save(user, changeset)
    dto(result)
  end

  defp dto(%{entries: entries} = page), do: %{page | entries: dto(entries)}
  defp dto(querys) when is_list(querys), do: QueryDTO.from(querys)
  defp dto(%LiveQuery{} = query), do: QueryDTO.from(query)
  defp dto({:ok, query}), do: {:ok, QueryDTO.from(query)}
  defp dto({:error, changeset} = other), do: other

end
