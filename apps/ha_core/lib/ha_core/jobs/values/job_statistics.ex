defmodule HaCore.Jobs.JobStatistics do
  @moduledoc """
  Stores job-related configuration options
  """
  use HaCore.Schema
  alias HaCore.Jobs.Job

  @primary_key {:job_id, :binary_id, autogenerate: false}

  schema "job_statistics" do
    field :started_at, :naive_datetime
    field :ended_at, :naive_datetime
  end

  @spec create_changeset(t, map) :: Changeset.t
  def create_changeset(struct, attrs \\ %{}) do
    required = ~w()a
    optional = ~w(
      job_id
      started_at
      ended_at
    )a

    struct
    |> cast(attrs, optional ++ required)
    |> validate_required(required)
  end

end
