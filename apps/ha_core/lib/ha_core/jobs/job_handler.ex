defmodule HaCore.Jobs.JobHandler do
  @moduledoc false
  use HaSupport.Consumer,
    types: ["import_created"],
    adapter: {HaSupport.Consumer.RedisAdapter, stream: "records", name: :redix_core_records}

  alias HaSupport.DomainEvent
  alias HaStore.Imports.Import
  alias HaCore.Jobs.{JobService, JobStatistics}

  @impl true
  def handle_events(events) do
    for event <- events do
      imported = struct(Import, event.data)
      statistics = create_statistics(imported)
      JobService.complete(event, statistics)
    end
    :ok
  end

  defp create_statistics(imported) do
    %JobStatistics{}
    |> JobStatistics.create_changeset(%{
      job_id: imported.job_id,
      started_at: imported.inserted_at,
      ended_at: imported.inserted_at
    })
    |> Ecto.Changeset.apply_changes
  end

end
