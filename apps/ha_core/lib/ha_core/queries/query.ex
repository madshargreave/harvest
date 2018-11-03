defmodule HaCore.Queries.Query do
  @moduledoc """
  Query model
  """
  use HaCore.Schema

  alias HaCore.Queries.Query
  alias HaCore.Queries.Events.{QuerySaved, QueryCreated, QueryDeleted}

  schema "queries" do
    field :user_id, :string
    field :destination_id, :string
    field :name, :string
    field :status, :string, default: "idle"
    field :primary_key, :string
    field :steps, {:array, :map}
    field :schedule, :string
    field :last_job_id, :string
    field :deleted_at, :naive_datetime
    field :deleted_by, :map, virtual: true

    timestamps()
  end

  @doc """
  Creates a new query
  """
  @spec save_changeset(HaCore.user, map) :: Changeset.t
  def save_changeset(user, attrs \\ %{}) do
    required = ~w(user_id steps)a
    optional = ~w(schedule)a

    %__MODULE__{}
    |> cast(attrs, optional ++ required)
    |> put_change(:user_id, user.id)
    |> validate_required(required)
    |> register_event(QuerySaved)
  end

  @doc """
  Creates a new query
  """
  @spec run_changeset(HaCore.user, t) :: Changeset.t
  def run_changeset(user, attrs \\ %{}) do
    required = ~w(name user_id destination_id primary_key steps)a
    optional = ~w()a

    %__MODULE__{}
    |> cast(attrs, optional ++ required)
    |> put_change(:user_id, user.id)
    |> validate_required(required)
    |> register_event(QueryCreated)
  end

  @doc """
  Deletes query
  """
  @spec delete_changeset(HaCore.user, t) :: Changeset.t
  def delete_changeset(user, query) do
    query
    |> change
    |> put_change(:deleted_at, NaiveDateTime.utc_now)
    |> put_change(:deleted_by, user)
    |> register_event(QueryDeleted)
  end

  defp validate_status_is(changeset, status, opts) do
    validate_is(changeset, :status, status, opts)
  end

  defp validate_status_is_not(changeset, status, opts) do
    validate_is_not(changeset, :status, status, opts)
  end

end
