defmodule HaCore.Queries.Store.DefaultImpl do
  @moduledoc false
  use HaCore.Queries.QueryStore
  import Ecto.Query

  alias HaCore.Repo
  alias HaCore.Queries.Query
  alias HaCore.Jobs.{Job, JobConfiguration}

  @preloaded []

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

    with %{entries: entries} = result <- Repo.paginate(query, cursor_fields: [:inserted_at], limit: pagination.limit) do
      entries = for entry <- entries, do: struct(Query, entry)
      %{result | entries: entries}
    end
  end

  @impl true
  def get_saved_queries(user, pagination) do
    query =
      from q in Query,
      where: q.saved == true and is_nil(q.deleted_at),
      order_by: [desc: q.inserted_at]

    Repo.paginate(query, cursor_fields: [:inserted_at], limit: pagination.limit)
  end

  @impl true
  def get_saved_query!(user, id) do
    Repo.one!(
      from q in Query,
      where: q.saved == true and q.id == ^id
    )
  end

  @impl true
  def get!(_user, id) do
    Query
    |> Repo.get!(id)
    |> Repo.preload(@preloaded)
  end

  @impl true
  def save(context, changeset) do
    with {:ok, entity} <- Repo.save(context, changeset) do
      {:ok, Repo.preload(entity, @preloaded)}
    end
  end

end
