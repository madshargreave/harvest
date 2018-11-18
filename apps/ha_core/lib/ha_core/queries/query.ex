defmodule HaCore.Queries.Query do
  @moduledoc """
  Query model
  """
  use HaCore.Schema

  alias HaCore.Jobs.Job
  alias HaCore.Queries.Query
  alias HaCore.Queries.Events

  schema "queries" do
    field :user_id, :binary_id
    field :name, :string
    field :status, :string
    field :query, :string
    field :params, :map, default: %{}
    field :saved, :boolean
    field :live, :boolean
    field :deleted_at, :naive_datetime
    field :deleted_by, :map, virtual: true
    has_one :job, Job
    has_many :jobs, Job
    timestamps()
  end

  @spec run_changeset(HaCore.user, t) :: Changeset.t
  def run_changeset(user, attrs \\ %{}) do
    required = ~w(user_id query)a
    optional = ~w(name params)a

    %__MODULE__{}
    |> cast(attrs, optional ++ required)
    |> cast_assoc(:job, required: true, with: &Job.create_changeset/2)
    |> put_change(:user_id, user.id)
    |> put_change(:status, "active")
    |> validate_required(required)
    |> register_event(Events.QueryCreated)
  end

  @spec save_changeset(HaCore.user, map) :: Changeset.t
  def save_changeset(user, query) do
    query
    |> change
    |> put_change(:saved, true)
    |> register_event(Events.QuerySaved)
  end

  @spec delete_changeset(HaCore.user, t) :: Changeset.t
  def delete_changeset(user, query) do
    query
    |> change
    |> put_change(:deleted_at, NaiveDateTime.utc_now)
    |> put_change(:deleted_by, user)
    |> register_event(Events.QueryDeleted)
  end

end
