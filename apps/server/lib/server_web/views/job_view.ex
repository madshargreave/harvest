defmodule Harvest.ServerWeb.JobView do
  use Harvest.ServerWeb, :view
  alias Harvest.ServerWeb.JobView

  def render("index.json", %{jobs: jobs}) do
    %{data: render_many(jobs, JobView, "job.json")}
  end

  def render("show.json", %{job: job}) do
    %{data: render_one(job, JobView, "job.json")}
  end

  def render("job.json", %{job: job}) do
    %{
      id: job.id,
      user_id: job.user_id,
      status: job.status,
      inserted_at: job.inserted_at
    }
  end
end
