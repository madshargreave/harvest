defmodule HaCore.Jobs.Job do
  @moduledoc """
  Query model
  """
  use HaCore.Schema

  alias HaCore.Commands.CreateJobCommand
  alias HaCore.Jobs.{JobStatistics, JobConfiguration}
  alias HaCore.Jobs.Events

  swagger_schema "jobs" do
    field :status, :string, default: "created"
    field :canceled_at, :naive_datetime
    has_one :configuration, JobConfiguration
    has_one :statistics, JobStatistics
    timestamps()
  end

  @spec create_changeset(HaCore.user, map) :: Changeset.t
  def create_changeset(user, attrs \\ %{}) do
    required = ~w()a
    optional = ~w()a

    %__MODULE__{}
    |> cast(attrs, optional ++ required)
    |> cast_assoc(:configuration, required: true)
    |> validate_required(required)
    |> register_event(Events.JobCreated)
  end

  @spec complete_changeset(t, map) :: Changeset.t
  def complete_changeset(job, attrs \\ %{}) do
    job
    |> cast(attrs, [])
    |> cast_assoc(:statistics, required: true)
    |> put_change(:status, "completed")
    |> register_event(Events.JobCompleted)
  end

end
