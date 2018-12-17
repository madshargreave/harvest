defmodule HaCore.Jobs.Job do
  @moduledoc """
  Query model
  """
  use HaCore.Schema

  alias HaCore.Commands.CreateJobCommand
  alias HaCore.Jobs.{JobStatistics, JobConfiguration}
  alias HaCore.Jobs.Events

  model "jobs" do
    field :status, :string, default: "created"
    field :canceled_at, :naive_datetime
    has_one :configuration, JobConfiguration
    has_one :statistics, JobStatistics
    timestamps()
  end

  @spec create_changeset(HaCore.user, CreateJobCommand.t) :: Changeset.t
  def create_changeset(user, command) do
    required = ~w()a
    optional = ~w()a

    %__MODULE__{}
    |> cast(%{
      configuration: %{
        query: command.query
      }
    }, optional ++ required)
    |> cast_assoc(:configuration, required: true)
    |> validate_required(required)
    |> register_event(Events.JobCreated)
  end

  @spec complete_changeset(t, CompleteJobCommand.t) :: Changeset.t
  def complete_changeset(job, command) do
    required = ~w(status)a
    optional = ~w()a

    job
    |> cast(%{
      status: "completed",
      statistics: %{
        started_at: command.started_at,
        ended_at: command.ended_at
      }
    }, optional ++ required)
    |> cast_assoc(:statistics, required: true)
    |> register_event(Events.JobCompleted)
  end

end
