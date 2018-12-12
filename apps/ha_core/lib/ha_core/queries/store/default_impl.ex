defmodule HaCore.Queries.Store.DefaultImpl do
  @moduledoc false
  use HaCore.Queries.QueryStore
  import Ecto.Query

  alias HaCore.Repo
  alias HaCore.Queries.Query

  @impl true
  def count(user) do
    Repo.count(Query)
  end

  @impl true
  def list(user) do
    Repo.all(Query)
  end

  @impl true
  def list_saved(user, pagination) do
    query =
      from q in Query,
      where: q.live

    Repo.paginate(query, cursor_fields: [:inserted_at], limit: pagination.limit)
  end

  @impl true
  def get!(user, id) do
    Repo.get!(Query, id)
  end

  @impl true
  def save(context, changeset) do
    with {:ok, entity} = Repo.save(context, changeset) do
      {:ok, Repo.preload(entity, [job: [:configuration, :statistics]])}
    end
  end

end
