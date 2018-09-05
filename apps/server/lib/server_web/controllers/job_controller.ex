defmodule Harvest.ServerWeb.JobController do
  use Harvest.ServerWeb, :controller
  alias Harvest.Server.Scheduling

  action_fallback Harvest.ServerWeb.FallbackController

  def index(conn, _params) do
    jobs = Scheduling.list_jobs()
    render(conn, "index.json", jobs: jobs)
  end

  def create(conn, %{"job" => job_params}) do
    with {:ok, job} <- Scheduling.create_job(job_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", job_path(conn, :show, job))
      |> render("show.json", job: job)
    end
  end

  def show(conn, %{"id" => id}) do
    job = Scheduling.get_job!(id)
    render(conn, "show.json", job: job)
  end

end
