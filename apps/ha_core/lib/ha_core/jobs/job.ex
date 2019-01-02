defmodule HaCore.Jobs.Job do
  @moduledoc """
  Query model
  """
  use HaCore.Schema

  alias HaCore.Tables.{Table, TableSchema}
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

  @spec create_changeset(HaCore.user, CreateJobCommand.t, TableSchema.t) :: Changeset.t
  def create_changeset(user, command, schema) do
    base_create_changeset(command, schema)
    |> register_event(Events.JobCreated)
  end

  @spec create_scheduled_changeset(CreateJobCommand.t, TableSchema.t) :: Changeset.t
  def create_scheduled_changeset(command, schema) do
    base_create_changeset(command, schema)
    |> put_change(:scheduled, true)
    |> register_event(Events.JobCreated)
  end

  @spec base_create_changeset(CreateJobCommand.t, TableSchema.t) :: Changeset.t
  defp base_create_changeset(command, schema) do
    required = ~w()a
    optional = ~w()a

    %__MODULE__{}
    |> cast(%{
      configuration: %{
        query: command.query
      }
    }, optional ++ required)
    |> cast_assoc(:configuration, required: true)
    |> put_destination(command, schema)
    |> validate_required(required)
  end

  defp put_destination(changeset, %{destination_id: nil} = command, schema),
    do: put_assoc(changeset, :destination, create_destination_changeset(schema))
  defp put_destination(changeset, %{destination_id: destination_id} = command, _schema),
    do: put_change(changeset, :destination_id, destination_id)

  defp create_destination_changeset(schema) do
    %Table{}
    |> cast(%{name: default_name()}, [:name])
    |> put_assoc(:schema, schema)
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

  ## Helpers

  defp default_name do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.to_string
    "table-#{now}"
  end

end
