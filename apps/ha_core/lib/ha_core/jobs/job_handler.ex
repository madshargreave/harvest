defmodule HaCore.Jobs.JobHandler do
  @moduledoc false
  use HaSupport.Consumer,
    topics: ["import_created"],
    adapter: {
      HaSupport.Consumer.RedisAdapter,
        stream: "records",
        redix: :redix_core_records
    }

  alias HaStore.Imports.Import
  alias HaCore.Jobs.{JobService, JobStatistics}

  @impl true
  def handle_event(event) do
    imported = struct(Import, event.data)
    statistics = create_statistics(imported)
    JobService.complete(event, statistics)
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
