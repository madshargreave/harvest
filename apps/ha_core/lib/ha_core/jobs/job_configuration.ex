defmodule HaCore.Jobs.JobConfiguration do
  @moduledoc """
  Query model
  """
  use HaCore.Schema
  alias HaCore.Jobs.{Job, Events}

  @primary_key {:job_id, :binary_id, autogenerate: true}

  schema "job_configurations" do
    field :query, :string
  end

  @spec changeset(HaCore.user, map) :: Changeset.t
  def changeset(user, attrs \\ %{}) do
    required = ~w(query)a
    optional = ~w()a

    %__MODULE__{}
    |> cast(attrs, optional ++ required)
    |> validate_required(required)
  end

end
