defmodule HaCore.Jobs.JobService do
  @moduledoc """
  Jobs service
  """
  alias ExCore.DTO.JobDTO
  alias HaCore.Jobs
  alias HaCore.Jobs.Store.DefaultImpl
  alias HaCore.Jobs.{
    Job,
    JobService,
    JobServiceStore
  }

  @store Application.get_env(:ha_core, :job_store_impl) || DefaultImpl

  @doc """
  Lists all live queries for user
  """
  @spec list(HaCore.user, HaCore.pagination) :: [JobDTO.t]
  def list(user, pagination) do
    page = @store.list(user, pagination)
    dto(page)
  end

  @doc """
  Get a single job
  """
  @spec get!(HaCore.user, Jobs.id) :: JobDTO.t
  def get!(user, job_id) do
    job = @store.get!(user, job_id)
    dto(job)
  end

  @doc """
  Creates a new job
  """
  @spec create(HaCore.user, map) :: {:ok, JobDTO.t} | {:error, InvalidChangesetError.t}
  def create(user, attrs \\ %{}) do
    changeset = Job.create_changeset(user, attrs)
    result = @store.save(user, changeset)
    dto(result)
  end

  defp dto(%{entries: entries} = page), do: %{page | entries: dto(entries)}
  defp dto(queries) when is_list(queries), do: JobDTO.from(queries)
  defp dto(%Job{} = job), do: JobDTO.from(job)
  defp dto({:ok, job}), do: {:ok, JobDTO.from(job)}
  defp dto({:error, changeset} = other), do: other

end
