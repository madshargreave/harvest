defmodule HaCore.Jobs.JobService do
  @moduledoc """
  Jobs service
  """
  alias ExCore.DTO.JobDTO
  alias HaCore.Jobs
  alias HaCore.Jobs.Store.DefaultImpl
  alias HaCore.Jobs.{Job, Store}

  @store Application.get_env(:ha_core, :job_store_impl) || DefaultImpl

  @doc """
  List all user jobs
  """
  @spec list(HaCore.user, HaCore.pagination) :: [JobDTO.t]
  def list(user, pagination) do
    page = @store.list(user, pagination)
    dto(page)
  end

  @doc """
  Get a single job
  """
  @spec get!(HaCore.user, Jobs.job_id) :: JobDTO.t
  def get!(user, job_id) do
    job = @store.get_job!(job_id)
    dto(job)
  end

  @doc """
  Creates a new job and enqueues it processing
  """
  @spec create(HaCore.user, map) :: {:ok, JobDTO.t} | {:error, InvalidChangesetError.t}
  def create(user, attrs \\ %{}) do
    changeset = Job.create_changeset(user, attrs)
    job = @store.save(user, changeset)
    dto(job)
  end

  @doc """
  Cancels a running job
  """
  @spec cancel(HaCore.user, Jobs.job_id) :: {:ok, JobDTO.t} | {:error, InvalidChangesetError.t}
  def cancel(user, job_id) do
    job = @store.get_user_job!(user, job_id)
    changeset = Job.cancel_changeset(user, job)
    updated = @store.save(user, changeset)
    dto(updated)
  end

  @doc """
  Marks the job as done
  """
  @spec complete(HaCore.context, Jobs.statistics) :: {:ok, JobDTO.t} | {:error, InvalidChangesetError.t}
  def complete(context, statistics) do
    job = @store.get_job!(statistics.job_id)
    changeset = Job.complete_changeset(job, statistics)
    updated = @store.save(context, changeset)
    dto(updated)
  end

  defp dto(%{entries: entries} = page), do: %{page | entries: dto(entries)}
  defp dto(jobs) when is_list(jobs), do: JobDTO.from(jobs)
  defp dto(%Job{} = job), do: JobDTO.from(job)
  defp dto({:ok, job}), do: {:ok, JobDTO.from(job)}

end
