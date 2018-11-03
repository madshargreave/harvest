defmodule HaCore.Shared.JobConfiguration do
  @moduledoc """
  Stores job-related configuration options
  """
  use HaCore.Schema

  embedded_schema do
    field :create_disposition, :string, default: "create_if_needed"
    field :write_disposition, :string, default: "write_truncate"

    field :priority, :string, default: "standard"
    field :use_source_cache, :boolean, default: false

    field :max_bad_records, :integer
    field :dry_run, :boolean, default: false
  end

  @spec create_changeset(map) :: Changeset.t
  def create_changeset(attrs \\ %{}) do
    required = ~w()a
    optional = ~w(
      create_disposition
      write_disposition
      priority
      use_source_cache
      max_bad_records
      dry_run
    )a

    %__MODULE__{}
    |> cast(attrs, optional ++ required)
    |> validate_required(required)
  end

end
