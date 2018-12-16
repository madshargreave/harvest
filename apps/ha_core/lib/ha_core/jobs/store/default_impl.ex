defmodule HaCore.Jobs.Store.DefaultImpl do
  @moduledoc false
  use HaCore.Jobs.JobStore
  import Ecto.Query

  alias Exd.AST
  alias HaCore.Repo
  alias HaCore.Jobs.Job

  @impl true
  def count(user) do
    Repo.count(Job)
  end

  @impl true
  def list(user, pagination) do
    query =
      from l in Job,
      order_by: [desc: l.inserted_at]

    Repo.paginate(query, cursor_fields: [:inserted_at], limit: pagination.limit)
  end

  @impl true
  def get!(user, id) do
    Repo.get!(Job, id)
  end

  @impl true
  def save(context, changeset) do
    with {:ok, entity} <- Repo.save(context, changeset) do
      {:ok, query} = HaDSL.parse(entity.configuration.query)

      meta = %{job_id: entity.id}
      command = %ExdStreams.Api.Commands.SelectCommand{query: query, meta: meta}
      ExdStreams.connect(context)
      results = ExdStreams.run(context, command)
      ExdStreams.close(context)
      {:ok, entity}
    end
  end

end
