defmodule HAServer.Jobs.Job do
  @moduledoc """
  Job model
  """
  use HAServer.Schema

  alias HAServer.Jobs.Job
  alias HAServer.Jobs.Events.{JobCanceled, JobDeleted, JobCreated}

  schema "jobs" do
    field :user_id, :string
    field :status, :string, default: "created"
    field :query, :map

    field :canceled_at, :naive_datetime
    field :canceled_by, :map, virtual: true

    field :deleted_at, :naive_datetime
    field :deleted_by, :map, virtual: true

    timestamps()
  end

  @doc """
  Creates a new job
  """
  @spec create_changeset(Jobs.user, map) :: Changeset.t
  def create_changeset(user, attrs \\ %{}) do
    required = ~w(user_id query)a
    optional = ~w(status)a

    %__MODULE__{}
    |> cast(attrs, optional ++ required)
    |> put_change(:user_id, user.id)
    |> validate_required(required)
    |> register_event(JobCreated)
  end

  @doc """
  Cancels the job
  """
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

  @doc """
  Deletes job
  """
  @spec delete_changeset(Jobs.user, Job.t) :: Changeset.t
  def delete_changeset(user, job) do
    job
    |> change
    |> put_change(:deleted_at, NaiveDateTime.utc_now)
    |> put_change(:deleted_by, user)
    |> put_change(:status, "deleted")
    |> validate_status_is_not("in_progress", message: "Job is running")
    |> validate_status_is_not("deleted", message: "Job has already been deleted")
    |> register_event(JobDeleted)
  end

  defp validate_status_is(changeset, status, opts) do
    validate_is(changeset, :status, status, opts)
  end

  defp validate_status_is_not(changeset, status, opts) do
    validate_is_not(changeset, :status, status, opts)
  end

end
