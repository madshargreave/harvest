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
  alias HaCore.Models
  alias HaCore.Commands.{
    CreateJobCommand,
    CompleteJobCommand
  }

  @store Application.get_env(:ha_core, :job_store_impl) || DefaultImpl

  @doc """
  Lists all live queries for user
  """
  @spec list(HaCore.user, HaCore.pagination) :: [JobDTO.t]
  def list(user, pagination) do
    @store.list(user, pagination)
  end

  @doc """
  Get a single job
  """
  @spec get!(HaCore.user, Jobs.id) :: JobDTO.t
  def get!(user, job_id) do
    @store.get!(user, job_id)
  end

  @doc """
  Creates a new job
  """
  @spec create(HaCore.user, CreateJobCommand.t) :: {:ok, JobDTO.t} | {:error, InvalidChangesetError.t}
  def create(user, command) do
    changeset = Job.create_changeset(user, command)
    @store.save(user, changeset)
  end

  @doc """
  Creates a new job
  """
  @spec complete(any, Jobs.id, CompleteJobCommand.t) :: {:ok, JobDTO.t} | {:error, InvalidChangesetError.t}
  def complete(context, job_id, command) do
    job = @store.get!(command.id)
    changeset = Job.complete_changeset(job, command)
    @store.save(context, changeset)
  end

end
