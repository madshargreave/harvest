defmodule HaCore.Jobs.JobStatistics do
  @moduledoc """
  Query model
  """
  use HaCore.Schema
  alias HaCore.Jobs.{Job, Events}

  @primary_key {:job_id, :binary_id, autogenerate: true}

  schema "job_statistics" do
    field :started_at, :naive_datetime
    field :ended_at, :naive_datetime
  end

  @spec changeset(HaCore.user, map) :: Changeset.t
  def changeset(user, attrs \\ %{}) do
    required = ~w(started_at ended_at)a
    optional = ~w()a

    %__MODULE__{}
    |> cast(attrs, optional ++ required)
    |> validate_required(required)
  end

end
