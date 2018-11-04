defmodule HaServer.JobController do
  use HaServer, :controller

  @user %HaCore.Accounts.User{id: "d5660ce8-6279-45ff-abcd-616f84fc51fe"}

  action_fallback HaServer.FallbackController

  def index(conn, _params) do
    jobs = HaCore.Jobs.list_jobs(@user)
    render(conn, "index.json", jobs: jobs)
  end

  def create(conn, %{"data" => job_params}) do
    with {:ok, job} <- HaCore.Jobs.create_job(@user, job_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", job_path(conn, :show, job))
      |> render("show.json", job: job)
    end
  end

  def show(conn, %{"id" => id}) do
    job = HaCore.Jobs.count_jobsget_job!(id)
    render(conn, "show.json", job: job)
  end

end
