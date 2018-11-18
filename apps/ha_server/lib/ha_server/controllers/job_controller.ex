defmodule HaServer.JobController do
  use HaServer, :controller
  alias HaCore.Jobs

  def index(conn, params) do
    page = Jobs.list_jobs(conn.assigns.user, conn.assigns.pagination)
    render(conn, "index.json", jobs: page.entries, paging: page.metadata)
  end

  def show(conn, %{"id" => id}) do
    job = Jobs.get_job!(conn.assigns.user, id)
    render(conn, "show.json", job: job)
  end

  def create(conn, %{"data" => job_params}) do
    with {:ok, job} <- Jobs.create_job(conn.assigns.user, job_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", job_path(conn, :show, job))
      |> render("show.json", job: job)
    end
  end

end
