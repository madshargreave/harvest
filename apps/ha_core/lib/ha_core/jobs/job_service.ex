defmodule HaCore.Jobs.JobService do
  @moduledoc """
  Jobs service
  """
  import Ecto

  alias Ha
  alias HaCore.Jobs
  alias HaCore.Jobs.Store.DefaultImpl
  alias HaCore.Jobs.{Job, Store}

  @store Application.get_env(:ha_server, :job_store_impl) || DefaultImpl

  @doc """
  Creates a new job and enqueues it processing
  """
  @spec create(HaCore.user, map) :: {:ok, Job.t} | {:error, InvalidChangesetError.t}
  def create(user, attrs \\ %{}) do
    changeset = Job.create_changeset(user, attrs)
    @store.save(user, changeset)
  end

  @doc """
  Cancels a running job
  """
  @spec cancel(HaCore.user, Jobs.job_id) :: {:ok, Job.t} | {:error, InvalidChangesetError.t}
  def cancel(user, job_id) do
    job = @store.get_user_job!(user, job_id)
    changeset = Job.cancel_changeset(user, job)
    @store.save(user, changeset)
  end

  @doc """
  Marks the job as done
  """
  @spec complete(any, Jobs.statistics) :: {:ok, Job.t} | {:error, InvalidChangesetError.t}
  def complete(context, statistics) do
    job = @store.get_job!(statistics.job_id)
    changeset = Job.complete_changeset(job, statistics)
    @store.save(context, changeset)
  end

end
