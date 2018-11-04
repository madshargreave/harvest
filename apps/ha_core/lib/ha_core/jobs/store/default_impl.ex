defmodule HaCore.Jobs.Store.DefaultImpl do
  @moduledoc false
  use HaCore.Jobs.JobStore
  import Ecto.Query

  alias HaCore.Repo
  alias HaCore.Jobs.Job

  @impl true
  def count(user) do
    Repo.count(Job)
  end

  @impl true
  def list(user, pagination) do
    query =
      from j in Job,
      left_join: s in assoc(j, :statistics),
      preload: [configuration: [:destination]],
      order_by: [desc: j.inserted_at],
      select: merge(j, %{statistics: s})

    Repo.paginate(query, cursor_fields: [:inserted_at], limit: pagination.limit)
  end

  @impl true
  def get_job!(id) do
    query =
      from j in Job,
      where: j.id == ^id,
      preload: [:statistics, :configuration]

    Repo.one!(query)
  end

  @impl true
  def get_user_job!(user, id) do
    Repo.get!(Job, id)
  end

  @impl true
  def save(changeset) do
    with {:ok, entity} = Repo.save(changeset) do
      {:ok, Repo.preload(entity, [:configuration, :statistics])}
    end
  end

  @impl true
  def save(context, changeset) do
    with {:ok, entity} = Repo.save(context, changeset) do
      {:ok, Repo.preload(entity, [:configuration, :statistics])}
    end
  end

end
