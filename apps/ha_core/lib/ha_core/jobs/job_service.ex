defmodule HaCore.Jobs.JobService do
  @moduledoc """
  Jobs service
  """
  alias HaCore.Jobs
  alias HaCore.Jobs.Store.DefaultImpl
  alias HaCore.Jobs.{
    Job,
    JobService,
    JobServiceStore
  }
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
    changeset =
      Job.create_changeset(user, %{
        configuration: %{
          query: command.query
        }
      })
    @store.save(user, changeset)
  end

  @doc """
  Creates a new job
  """
  @spec complete(HaCore.context, CompleteJobCommand.t) :: {:ok, Job.t} | {:error, InvalidChangesetError.t}
  def complete(context, command) do
    job = @store.get!(command.id)
    changeset =
      Job.complete_changeset(job, %{
        statistics: %{
          started_at: command.started_at,
          ended_at: command.ended_at
        }
      })
    @store.save(context, changeset)
  end

end
