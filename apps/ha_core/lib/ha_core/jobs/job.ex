defmodule HaCore.Jobs.Job do
  @moduledoc """
  Job model
  """
  use HaCore.Schema

  alias HaCore.Constants
  alias HaCore.Tables.Table
  alias HaCore.Jobs.Job
  alias HaCore.Jobs.Events.{JobCanceled, JobCreated}

  @statuses ~w(created done)
  @create_dispositions ~w(create_if_needed never)
  @write_dispositions ~w(write_truncate write_append write_empty)
  @priorities ~w(standard)

  schema "jobs" do
    field :status, :string, default: "created"

    field :params, :map, default: %{}
    field :steps, {:array, :map}

    field :canceled_at, :naive_datetime
    field :canceled_by, :map, virtual: true

    field :create_disposition, :string, default: "create_if_needed"
    field :write_disposition, :string, default: "write_truncate"

    field :priority, :string, default: "standard"
    field :use_source_cache, :boolean, default: false

    field :max_bad_records, :integer
    field :dry_run, :boolean, default: false

    field :schema, :map, virtual: true
    belongs_to :destination, Table

    timestamps()
  end

  @doc """
  Creates a new job
  """
  @spec create_changeset(Jobs.user, map) :: Changeset.t
  def create_changeset(user, attrs \\ %{}) do
    required = ~w(steps)a
    optional = ~w(
      create_disposition
      write_disposition
      priority
      use_source_cache
      max_bad_records
      dry_run
      schema
    )a

    %__MODULE__{}
    |> cast(attrs, optional ++ required)
    |> cast_assoc(:destination, required: false)
    |> create_table_maybe
    |> validate_inclusion(:status, @statuses)
    |> validate_inclusion(:create_disposition, @create_dispositions)
    |> validate_inclusion(:write_disposition, @write_dispositions)
    |> validate_inclusion(:priority, @priorities)
    |> validate_required(required)
    |> register_event(JobCreated)
  end
  defp create_table_maybe(changeset) do
    if should_create_table?(changeset) do
      schema = get_field(changeset, :schema, %{}) |> AtomicMap.convert
      table_changeset = Table.create_changeset(%{
        name: "destination-table-1",
        primary_key: schema.primary_key
      })
      put_assoc(changeset, :destination, table_changeset)
    else
      changeset
    end
  end
  defp create_table_maybe(changeset), do: changeset

  defp destination_specified?(changeset),
    do: !!get_field(changeset, :destination)
  defp write_disposition_create?(changeset),
    do: get_field(changeset, :write_disposition) == "create_if_needed"
  defp should_create_table?(changeset), do:
    !destination_specified?(changeset) || write_disposition_create?(changeset)

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

  defp validate_status_is(changeset, status, opts) do
    validate_is(changeset, :status, status, opts)
  end

  defp validate_status_is_not(changeset, status, opts) do
    validate_is_not(changeset, :status, status, opts)
  end

end
