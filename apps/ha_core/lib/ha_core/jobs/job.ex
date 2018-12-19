defmodule HaCore.Jobs.Job do
  @moduledoc """
  Query model
  """
  use HaCore.Schema

  alias HaCore.Tables.Table
  alias HaCore.Commands.{CreateJobCommand, CompleteJobCommand}
  alias HaCore.Jobs.{JobStatistics, JobConfiguration}
  alias HaCore.Jobs.Events

  swagger_schema "jobs" do
    field :status, :string, default: "created"
    field :canceled_at, :naive_datetime
    has_one :configuration, JobConfiguration
    has_one :statistics, JobStatistics
    belongs_to :destination, Table
    timestamps()
  end

  @spec create_changeset(HaCore.user, CreateJobCommand.t) :: Changeset.t
  def create_changeset(user, %{destination_id: nil} = command) do
    required = ~w()a
    optional = ~w()a

    %__MODULE__{}
    |> cast(%{
      destination: %{},
      configuration: %{
        query: command.query
      }
    }, optional ++ required)
    |> cast_assoc(:destination, required: true)
    |> cast_assoc(:configuration, required: true)
    |> validate_required(required)
    |> register_event(Events.JobCreated)
  end

  @spec complete_changeset(t, CompleteJobCommand.t) :: Changeset.t
  def complete_changeset(job, command) do
    job
    |> cast(%{
      statistics: %{
        started_at: command.started_at,
        ended_at: command.ended_at
      }
    }, [])
    |> cast_assoc(:statistics, required: true)
    |> put_change(:status, "completed")
    |> register_event(Events.JobCompleted)
  end

end
