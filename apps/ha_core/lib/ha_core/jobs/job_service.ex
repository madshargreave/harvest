defmodule HaCore.Jobs.JobService do
  @moduledoc """
  Jobs service
  """
  alias HaCore.Jobs.{
    Job,
    JobStore,
    SchemaResolver
  }

  alias HaCore.Commands.{
    CreateJobCommand,
    CompleteJobCommand
  }

  @doc """
  Creates a new job
  """
  @spec create(HaCore.context, CreateJobCommand.t) :: {:ok, Job.t} | {:error, InvalidChangesetError.t}
  def create(user, command) do
    schema = SchemaResolver.resolve!(command.query)
    changeset = Job.create_changeset(user, command, schema)
    JobStore.save(user, changeset)
  end

  @doc """
  Sets the status of an existing job as complete
  """
  @spec complete(HaCore.context, CompleteJobCommand.t) :: {:ok, Job.t} | {:error, InvalidChangesetError.t}
  def complete(context, command) do
    job = JobStore.get!(command.id)
    changeset = Job.complete_changeset(job, command)
    JobStore.save(context, changeset)
  end

end
