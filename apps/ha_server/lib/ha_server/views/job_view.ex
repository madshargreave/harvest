defmodule HaServer.JobView do
  use HaServer, :view
  alias HaServer.JobView

  def render("index.json", %{jobs: jobs, paging: paging}) do
    %{
      data: render_many(jobs, JobView, "job.json"),
      paging: paging
    }
  end

  def render("show.json", %{job: job}) do
    %{data: render_one(job, JobView, "job.json")}
  end

  def render("job.json", %{job: job}) do
    job
  end

end
