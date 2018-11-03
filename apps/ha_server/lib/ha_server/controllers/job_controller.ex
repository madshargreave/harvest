defmodule HaServer.JobController do
  use HaServer, :controller

  action_fallback HaServer.FallbackController

  def index(conn, _params) do
    jobs = Jobs.list_jobs()
    render(conn, "index.json", jobs: jobs)
  end

  def create(conn, %{"data" => job_params}) do
    user = %HaCore.Accounts.User{id: "abc"}
    with {:ok, job} <- HaCore.Jobs.create_job(user, job_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", job_path(conn, :show, job))
      |> render("show.json", job: job)
    end
  end

  def show(conn, %{"id" => id}) do
    job = HaCore.get_job!(id)
    render(conn, "show.json", job: job)
  end

end
