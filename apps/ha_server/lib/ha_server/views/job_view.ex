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
      id: job.id,
      status: job.status,
      configuration: %{
        job_type: "query",
        query: %{
          write_disposition: job.write_disposition,
          create_disposition: job.create_disposition,
          priority: job.priority,
          max_bad_records: job.max_bad_records,
          destination: %{
            table_id: job.destination.id
          }
        }
      },
      inserted_at: job.inserted_at
    }
  end
end
