defmodule HaServer.JobView do
  use HaServer, :view
  alias HaServer.JobView

  def render("index.json", %{jobs: jobs}) do
    %{data: render_many(jobs, JobView, "job.json")}
  end

  def render("show.json", %{job: job}) do
    %{data: render_one(job, JobView, "job.json")}
  end

  def render("job.json", %{job: job}) do
    %{
      type: "job.object",
      id: job.id,
      status: job.status,
      statistics: render("statistics.json", %{job: job}),
      configuration: render("configuration.json", %{job: job}),
      inserted_at: job.inserted_at,
      updated_at: job.updated_at
    }
  end

  def render("configuration.json", %{job: job}) do
    %{
      write_disposition: job.configuration.write_disposition,
      create_disposition: job.configuration.create_disposition,
      priority: job.configuration.priority,
      max_bad_records: job.configuration.max_bad_records,
      destination: %{
        table_id: job.configuration.destination.id
      }
    }
  end

  def render("statistics.json", %{
    job: %{statistics: statistics} = _job
  })
    when not is_nil(statistics)
  do
    %{
      started_at: statistics.started_at,
      ended_at: statistics.ended_at
    }
  end
  def render("statistics.json", _), do: nil

end
