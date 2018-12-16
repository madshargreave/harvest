defmodule HaCore.Jobs.Job do
  @moduledoc """
  Query model
  """
  use HaCore.Schema

  alias HaCore.Jobs.JobConfiguration
  alias HaCore.Jobs.Events

  schema "jobs" do
    field :status, :string, default: "created"
    field :statistics, :map
    field :canceled_at, :naive_datetime
    has_one :configuration, JobConfiguration
    timestamps()
  end

  @spec create_changeset(HaCore.user, map) :: Changeset.t
  def create_changeset(user, attrs \\ %{}) do
    required = ~w()a
    optional = ~w()a

    %__MODULE__{}
    |> cast(attrs, optional ++ required)
    |> cast_assoc(:configuration, required: true)
    |> validate_required(required)
    |> register_event(Events.JobCreated)
  end

end
