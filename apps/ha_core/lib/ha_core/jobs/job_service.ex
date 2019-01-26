defmodule HaCore.Jobs.JobService do
  @moduledoc """
  Jobs service
  """
  alias HaCore.{Jobs, Queries, Schemas}
  alias HaCore.Jobs.{
    Job,
    JobStore,
    Commands
  }

  @doc """
  Creates a new job
  """
  @spec create(HaCore.context, Commands.CreateJobCommand.t) :: {:ok, Job.t} | {:error, InvalidChangesetError.t}
  def create(user, command) do
    with {:ok, plan} <- Queries.resolve_query(user, command.query) do
      changeset = Job.create_changeset(user, command, plan)
      JobStore.save(user, changeset)
    end
  end

  @doc """
  Creates a new job
  """
  @spec create_scheduled(Commands.CreateJobCommand.t) :: {:ok, Job.t} | {:error, InvalidChangesetError.t}
  def create_scheduled(command) do
    with {:ok, plan} <- Queries.resolve_query(nil, command.query) do
      changeset = Job.create_scheduled_changeset(command, plan)
      JobStore.save(nil, changeset)
    end
  end

  @doc """
  Sets the status of an existing job as complete
  """
  @spec start(HaCore.context, Commands.StartJobCommand.t) :: {:ok, Job.t} | {:error, InvalidChangesetError.t}
  def start(context, command) do
    job = JobStore.get!(command.id)
    changeset = Job.start_changeset(job, command)
    JobStore.save(context, changeset)
  end

  @doc """
  Sets the status of an existing job as complete
  """
  @spec complete(HaCore.context, Commands.CompleteJobCommand.t) :: {:ok, Job.t} | {:error, InvalidChangesetError.t}
  def complete(context, command) do
    job = JobStore.get!(command.id)
    changeset = Job.complete_changeset(job, command)
    JobStore.save(context, changeset)
  end

end
