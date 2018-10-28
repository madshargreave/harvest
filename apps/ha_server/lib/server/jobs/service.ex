defmodule HAServer.Jobs.Service do
  @moduledoc """
  Jobs service
  """
  import Ecto

  alias HAServer.Jobs
  alias HAServer.Jobs.Store.DefaultImpl
  alias HAServer.Jobs.{Job, Store}

  @store_impl Application.get_env(:ha_server, :job_store_impl) || DefaultImpl

  @doc """
  Creates a new job and enqueues it processing
  """
  @spec create(Jobs.user, map) :: {:ok, Job.t} | {:error, InvalidChangesetError.t}
  def create(user, attrs \\ %{}) do
    changeset = Job.create_changeset(user, attrs)
    @store_impl.save(changeset)
  end

  @doc """
  Deletes an existing job
  """
  @spec delete(Jobs.user, Jobs.job_id) :: {:ok, Job.t} | {:error, InvalidChangesetError.t}
  def delete(user, job_id) do
    job = @store_impl.get!(user, job_id)
    changeset = Job.delete_changeset(user, job)
    @store_impl.save(changeset)
  end

  @doc """
  Cancels a running job
  """
  @spec cancel(Jobs.user, Jobs.job_id) :: {:ok, Job.t} | {:error, InvalidChangesetError.t}
  def cancel(user, job_id) do
    job = @store_impl.get!(user, job_id)
    changeset = Job.cancel_changeset(user, job)
    @store_impl.save(changeset)
  end

end
