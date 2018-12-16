defmodule HaServer.JobController do
  use HaServer, :controller
  alias HaCore.Jobs

  action_fallback HaServer.FallbackController

  swagger_path :index do
    get "/jobs"
    description "List jobs"
    tag "Jobs"
    paging
    operation_id "list_jobs"
    response 200, "Success", Schema.ref(:Jobs)
  end

  def index(conn, params) do
    page = Jobs.list_jobs(conn.assigns.user, conn.assigns.pagination)
    render(conn, "index.json", jobs: page.entries, paging: page.metadata)
  end

  swagger_path :show do
    get "/jobs/{job_id}"
    description "Get job"
    tag "Jobs"
    parameters do
      job_id :path, :string, "Job ID", required: true
    end
    operation_id "get_job"
    response 200, "Success", Schema.ref(:Job)
    response 404, "Not found"
  end

  def show(conn, %{"id" => id}) do
    job = Jobs.get_job!(conn.assigns.user, id)
    render(conn, "show.json", job: job)
  end

  swagger_path :create do
    post "/jobs"
    description "Create a new job"
    tag "Jobs"
    parameters do
      job :body, Schema.ref(:JobParams), "Job attributes"
    end
    operation_id "create_job"
    response 200, "Success", Schema.ref(:Job)
    response 422, "Invalid parameters", Schema.ref(:Job)
  end

  def create(conn, params) do
    with {:ok, job} <- Jobs.create_job(conn.assigns.user, params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", job_path(conn, :show, job))
      |> render("show.json", job: job)
    end
  end

  def swagger_definitions do
    %{
      JobParams: swagger_schema do
        title "Job"
        description "A job"
        properties do
          configuration Schema.ref(:JobConfiguration), "Job configuration options", required: true
        end
      end,
      Job: swagger_schema do
        title "Job"
        description "A job"
        properties do
          id :string, "The ID of the job", required: true
          name :string, "The name of the job", required: true
          status :string, "The status of the job", required: true
          configuration Schema.ref(:JobConfiguration), "Job configuration options", required: true
        end
        example %{
          id: "123",
          name: "my-job",
          status: "in_progress"
        }
      end,
      JobConfiguration: swagger_schema do
        title "JobConfiguration"
        description "Runtime configuration options for a job"
        properties do
          query :string, "The query string to execute", required: true
        end
      end,
      Jobs: swagger_schema do
        title "Jobs"
        description "A collection of Jobs"
        type :array
        items Schema.ref(:Job)
      end
    }
  end

end
