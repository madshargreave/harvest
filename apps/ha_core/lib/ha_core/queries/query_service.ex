defmodule HaCore.Queries.QueryService do
  @moduledoc """
  Jobs service
  """
  alias ExCore.DTO.QueryDTO
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
  @spec save(HaCore.user, map) :: {:ok, QueryDTO.t} | {:error, InvalidChangesetError.t}
  def save(user, attrs \\ %{}) do
    changeset = Query.save_changeset(user, attrs)
    result = @store.save(user, changeset)
    dto(result)
  end

  @doc """
  Runs a saved query
  """
  @spec run(HaCore.user, map) :: {:ok, QueryDTO.t} | {:error, InvalidChangesetError.t}
  def run(user, attrs \\ %{}) do
    changeset = Query.run_changeset(user, attrs)
    result = @store.save(user, changeset)
    dto(result)
  end

  @doc """
  Deletes a saved query
  """
  @spec delete(HaCore.user, Queries.id) :: {:ok, QueryDTO.t} | {:error, InvalidChangesetError.t}
  def delete(user, query_id) do
    query = @store.get!(user, query_id)
    changeset = Query.delete_changeset(user, query)
    result = @store.save(user, changeset)
    dto(result)
  end

  defp dto(queries) when is_list(queries), do: QueryDTO.from(queries)
  defp dto({:ok, query}), do: {:ok, QueryDTO.from(query)}
  defp dto(other), do: other

end
