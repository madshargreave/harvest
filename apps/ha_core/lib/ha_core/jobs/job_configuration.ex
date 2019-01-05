defmodule HaCore.Jobs.JobConfiguration do
  @moduledoc """
  Query model
  """
  use HaCore.Schema

  alias HaCore.Jobs.{Job, Events}

  @derive {Poison.Encoder, except: [:__meta__, :job_id]}
  @primary_key {:job_id, :binary_id, autogenerate: true}

  swagger_schema "job_configurations" do
    field :query, :string
  end

  @spec changeset(map) :: Changeset.t
  def changeset(struct, attrs \\ %{}) do
    required = ~w(query)a
    optional = ~w()a

    struct
    |> cast(attrs, optional ++ required)
    |> validate_required(required)
  end

end
