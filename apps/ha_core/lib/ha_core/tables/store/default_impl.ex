defmodule HaCore.Tables.Store.DefaultImpl do
  @moduledoc false
  use HaCore.Tables.TableStore
  import Ecto.Query

  alias HaCore.Repo
  alias HaCore.Jobs.Job
  alias HaCore.Tables.Table

  @preloaded [:schema]

  @impl true
  def list(user, pagination) do
    query =
      from t in Table,
      where: t.saved and is_nil(t.deleted_at),
      order_by: [desc: t.favorited, desc: t.inserted_at],
      preload: ^@preloaded

    Repo.paginate(query, cursor_fields: [:inserted_at], limit: pagination.limit)
  end

  @impl true
  def get_by_user!(user, id) do
    Table
    |> Repo.get!(id)
    |> Repo.preload(@preloaded)
  end

  @impl true
  def get_by_job!(user, job_id) do
    query =
      from t in Table,
      join: j in Job, on: j.destination_id == t.id,
      where: j.id == ^job_id

    Repo.one!(query)
  end

  @impl true
  def save(context, changeset) do
    with {:ok, entity} <- Repo.save(context, changeset) do
      {:ok, Repo.preload(entity, @preloaded)}
    end
  end

end
