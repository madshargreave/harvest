defmodule HaCore.Streams.StreamService do
  @moduledoc """
  Jobs service
  """
  alias ExCore.DTO.QueryDTO
  alias HaCore.Streams
  alias HaCore.Streams.Store.DefaultImpl
  alias HaCore.Streams.{
    Stream,
    StreamStore
  }

  @store Application.get_env(:ha_core, :stream_store_impl) || DefaultImpl

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
  @spec get!(HaCore.user, Streams.id) :: QueryDTO.t
  def get!(user, query_id) do
    query = @store.get!(user, query_id)
    dto(query)
  end

  @doc """
  Registers a live query
  """
  @spec register(HaCore.user, map) :: {:ok, QueryDTO.t} | {:error, InvalidChangesetError.t}
  def register(user, attrs \\ %{}) do
    changeset = Stream.register_changeset(user, attrs)
    result = @store.save(user, changeset)
    dto(result)
  end

  @doc """
  Pauses a live query
  """
  @spec pause(HaCore.user, Streams.id) :: {:ok, QueryDTO.t} | {:error, InvalidChangesetError.t}
  def pause(user, stream_id) do
    stream = @store.get!(user, stream_id)
    changeset = Stream.pause_changeset(stream)
    result = @store.save(user, changeset)
    dto(result)
  end

  @doc """
  Resumes a paused live query
  """
  @spec resume(HaCore.user, Streams.id) :: {:ok, QueryDTO.t} | {:error, InvalidChangesetError.t}
  def resume(user, stream_id) do
    stream = @store.get!(user, stream_id)
    changeset = Stream.resume_changeset(stream)
    result = @store.save(user, changeset)
    dto(result)
  end

  @doc """
  Deletes a live query
  """
  @spec delete(HaCore.user, Streams.id) :: {:ok, QueryDTO.t} | {:error, InvalidChangesetError.t}
  def delete(user, stream_id) do
    stream = @store.get!(user, stream_id)
    changeset = Stream.delete_changeset(stream)
    result = @store.save(user, changeset)
    dto(result)
  end

  defp dto(%{entries: entries} = page), do: %{page | entries: dto(entries)}
  defp dto(queries) when is_list(queries), do: QueryDTO.from(queries)
  defp dto(%Stream{} = query), do: QueryDTO.from(query)
  defp dto({:ok, query}), do: {:ok, QueryDTO.from(query)}
  defp dto({:error, changeset} = other), do: other

end
