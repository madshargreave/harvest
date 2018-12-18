defmodule HaCore.Jobs.Store.DefaultImpl do
  @moduledoc false
  use HaCore.Jobs.JobStore
  import Ecto.Query

  alias Exd.AST
  alias HaCore.Repo
  alias HaCore.Jobs.Job

  @preloaded [:statistics, :configuration, :destination]

  @impl true
  def count(user) do
    Repo.count(Job)
  end

  @impl true
  def list(user, pagination) do
    query =
      from l in Job,
      order_by: [desc: l.inserted_at],
      preload: ^@preloaded

    Repo.paginate(query, cursor_fields: [:inserted_at], limit: pagination.limit)
  end

  @impl true
  def get_by_user!(user, id) do
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
    with {:ok, entity} <- Repo.save(context, changeset),
         entity = Repo.preload(entity, @preloaded),
         {:ok, query} = HaDSL.parse(entity.configuration.query) do
      if entity.status == "created" do
        meta = %{
          job_id: entity.id,
          actor_id: HaSupport.Context.actor_id(context),
          correlation_id: HaSupport.Context.correlation_id(context)
        }
        command = %ExdStreams.Api.Commands.SelectCommand{query: query, meta: meta}
        ExdStreams.connect(context)
        results = ExdStreams.run(context, command)
        ExdStreams.close(context)
      end
      {:ok, entity}
    end
  end

end
