defmodule HaCore.Jobs.Job do
  @moduledoc """
  Job model
  """
  use HaCore.Schema

  alias HaCore.Constants
  alias HaCore.Tables.Table
  alias HaCore.Jobs.{Job, JobQuery, JobConfiguration, JobStatistics}
  alias HaCore.Jobs.Events.{JobCanceled, JobCreated, JobCompleted}

  @statuses ~w(created done)

  schema "jobs" do
    field :status, :string, default: "created"
    field :canceled_at, :naive_datetime
    field :canceled_by, :map, virtual: true
    field :steps, {:array, :map}
    has_one :configuration, JobConfiguration
    has_one :statistics, JobStatistics
    timestamps()
  end

  @spec create_changeset(Jobs.user, map) :: Changeset.t
  def create_changeset(user, attrs \\ %{}) do
    required = ~w(steps)a
    optional = ~w()a

    %__MODULE__{}
    |> cast(attrs, optional ++ required)
    |> cast_assoc(:configuration, required: true, with: &JobConfiguration.create_changeset/2)
    |> validate_inclusion(:status, @statuses)
    |> validate_required(required)
    |> register_event(JobCreated)
  end

  @spec cancel_changeset(Jobs.user, Job.t) :: Changeset.t
  def cancel_changeset(user, job) do
    job
    |> change
    |> put_change(:canceled_at, NaiveDateTime.utc_now)
    |> put_change(:canceled_by, user)
    |> put_change(:status, "canceled")
    |> validate_status_is("in_progress", message: "Job can only be canceled if already running")
    |> register_event(JobCanceled)
  end

  @spec complete_changeset(Job.t, JobStatistics.t) :: Changeset.t
  def complete_changeset(job, statistics) do
    job
    |> change
    |> put_change(:status, "complete")
    |> put_assoc(:statistics, statistics)
    |> cast_assoc(:statistics, required: true, with: &JobConfiguration.create_changeset/2)
    |> validate_status_is("created", message: "Cannot mark job as done as it is not running")
    |> register_event(JobCompleted)
  end

  defp validate_status_is(changeset, status, opts) do
    validate_is(changeset, :status, status, opts)
  end

  defp validate_status_is_not(changeset, status, opts) do
    validate_is_not(changeset, :status, status, opts)
  end

end
