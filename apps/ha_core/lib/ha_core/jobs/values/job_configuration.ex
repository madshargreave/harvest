defmodule HaCore.Jobs.JobConfiguration do
  @moduledoc """
  Stores job-related configuration options
  """
  use HaCore.Schema

  alias HaCore.Tables.Table
  alias HaCore.Jobs.Job

  @create_dispositions ~w(create_if_needed never)
  @write_dispositions ~w(write_truncate write_append write_empty)
  @priorities ~w(standard)

  @primary_key {:job_id, :binary_id, autogenerate: false}

  schema "job_configurations" do
    field :create_disposition, :string, default: "create_if_needed"
    field :write_disposition, :string, default: "write_truncate"
    field :priority, :string, default: "standard"
    field :use_source_cache, :boolean, default: false
    field :max_bad_records, :integer
    field :dry_run, :boolean, default: false
    field :query_params, :map, default: %{}
    field :schema, :map, virtual: true
    belongs_to :destination, Table
  end

  @spec create_changeset(t, map) :: Changeset.t
  def create_changeset(struct, attrs \\ %{}) do
    required = ~w()a
    optional = ~w(
      job_id
      create_disposition
      write_disposition
      priority
      use_source_cache
      max_bad_records
      dry_run
      query_params
      schema
    )a

    struct
    |> cast(attrs, optional ++ required)
    |> cast_assoc(:destination)
    |> create_table_maybe
    |> validate_inclusion(:create_disposition, @create_dispositions)
    |> validate_inclusion(:write_disposition, @write_dispositions)
    |> validate_inclusion(:priority, @priorities)
    |> validate_required(required)
  end

  defp create_table_maybe(changeset) do
    if should_create_table?(changeset) do
      schema = (get_field(changeset, :schema) || %{}) |> AtomicMap.convert
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
  defp should_create_table?(changeset),
    do: !destination_specified?(changeset) || write_disposition_create?(changeset)

end
