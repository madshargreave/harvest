defmodule Harvest.ServerWeb.JobController do
  use Harvest.ServerWeb, :controller

  alias Harvest.Server.Jobs
  alias Harvest.Server.Jobs.Service, as: JobService

  action_fallback Harvest.ServerWeb.FallbackController

  def index(conn, _params) do
    jobs = Jobs.list_jobs()
    render(conn, "index.json", jobs: jobs)
  end

  def create(conn, %{"data" => job_params}) do
    with {:ok, job} <- JobService.create_job(job_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", job_path(conn, :show, job))
      |> render("show.json", job: job)
    end
  end

  def show(conn, %{"id" => id}) do
    job = Jobs.get_job!(id)
    render(conn, "show.json", job: job)
  end

end
