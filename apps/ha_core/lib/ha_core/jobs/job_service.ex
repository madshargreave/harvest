defmodule HaCore.Jobs.JobService do
  @moduledoc """
  Jobs service
  """
  alias HaCore.Jobs.Store.DefaultImpl
  alias HaCore.Jobs.Job
  alias HaCore.Commands.{
    CreateJobCommand,
    CompleteJobCommand
  }

  @store Application.get_env(:ha_core, :job_store_impl) || DefaultImpl

  @doc """
  Creates a new job
  """
  @spec create(HaCore.context, CreateJobCommand.t) :: {:ok, Job.t} | {:error, InvalidChangesetError.t}
  def create(user, command) do
    changeset = Job.create_changeset(user, command)
    @store.save(user, changeset)
  end

  @doc """
  Sets the status of an existing job as complete
  """
  @spec complete(HaCore.context, CompleteJobCommand.t) :: {:ok, Job.t} | {:error, InvalidChangesetError.t}
  def complete(context, command) do
    job = @store.get!(command.id)
    changeset = Job.complete_changeset(job, command)
    @store.save(context, changeset)
  end

end
