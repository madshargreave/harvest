defmodule HaCore.Jobs.Store.DefaultImpl do
  @moduledoc false
  use HaCore.Jobs.JobStore
  import Ecto.Query

  alias Exd.AST
  alias HaCore.Repo
  alias HaCore.Jobs.Job

  @preloaded [:statistics, :configuration, destination: [:schema]]

  @impl true
  def count(_user) do
    Repo.count(Job)
  end

  @impl true
  def list(_user, pagination) do
    query =
      from l in Job,
      order_by: [desc: l.inserted_at],
      preload: ^@preloaded

    Repo.paginate(query, cursor_fields: [:inserted_at], limit: pagination.limit)
  end

  @impl true
  def get_by_user!(_user, id) do
    Job
    |> Repo.get!(id)
    |> Repo.preload(@preloaded)
  end

  @impl true
  def get!(id) do
    Job
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
