defmodule HaCore.Queries.Store.DefaultImpl do
  @moduledoc false
  use HaCore.Queries.QueryStore

  import Ecto.Query
  alias HaCore.Queries.{QuerySchedule, Query}
  alias HaCore.Jobs.{Job, JobConfiguration}

  @repo Application.get_env(:ha_core, :repo_impl) || HaCore.Repo

  @preloaded [:schedule]

  @impl true
  def get_latest_queries(user, pagination) do
    latest_queries =
        from j in Job,
        join: jc in JobConfiguration,
          on: j.id == jc.job_id,
        distinct: jc.query,\
        order_by: [desc: jc.query, desc: j.inserted_at],
        select: %{
          id: j.id,
          query: jc.query,
          inserted_at: j.inserted_at
        }
    query =
      from s in subquery(latest_queries),
      order_by: [desc: s.inserted_at]

    with %{entries: entries} = result <- @repo.paginate(query, cursor_fields: [:inserted_at], limit: pagination.limit) do
      entries = for entry <- entries,
        do: struct(Query, Map.put(entry, :schedule, nil))
      %{result | entries: entries}
    end
  end

  @impl true
  def get_saved_queries(user, pagination) do
    query =
      from q in Query,
      where: q.saved and is_nil(q.deleted_at),
      order_by: [desc: q.inserted_at],
      preload: ^@preloaded

    @repo.paginate(query, cursor_fields: [:inserted_at], limit: pagination.limit)
  end

  @impl true
  def get_saved_query!(user, id) do
    @repo.one!(
      from q in Query,
      where: q.saved and q.id == ^id
    )
  end

  @impl true
  def stream_scheduled_queries(callback) do
    stream = @repo.stream(
      from q in Query,
      join: s in QuerySchedule, on: q.schedule_id == s.id,
      where: is_nil(q.deleted_at) and s.active,
      preload: ^@preloaded
    )
    @repo.transaction(fn ->
      stream
      |> Stream.map(callback)
      |> Stream.run
    end)
  end

  @impl true
  def get!(_user, id) do
    Query
    |> @repo.get!(id)
    |> @repo.preload(@preloaded)
  end

  @impl true
  def save(context, changeset) do
    IO.inspect "Saving: #{inspect changeset}"
    with {:ok, entity} <- @repo.save(context, changeset) do
      IO.inspect "Success! #{inspect entity}"
      {:ok, @repo.preload(entity, @preloaded)} |> IO.inspect
    end
  end

end
