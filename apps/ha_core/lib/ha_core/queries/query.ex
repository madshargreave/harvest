defmodule HaCore.Queries.Query do
  @moduledoc """
  Query model
  """
  use HaCore.Schema

  alias HaCore.Queries.Query
  alias HaCore.Queries.Events.{QuerySaved, QueryRunScheduled, QueryDeleted}

  schema "queries" do
    field :user_id, :string
    field :name, :string
    field :status, :string, default: "idle"
    field :query, :map
    field :schedule, :string
    field :last_started_at, :naive_datetime
    field :last_finished_at, :naive_datetime
    field :deleted_at, :naive_datetime
    field :deleted_by, :map, virtual: true

    timestamps()
  end

  @doc """
  Creates a new query
  """
  @spec save_changeset(HaCore.user, map) :: Changeset.t
  def save_changeset(user, attrs \\ %{}) do
    required = ~w(user_id query)a
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
  def run_changeset(user, query) do
    query
    |> change
    |> put_change(:status, "running")
    |> validate_status_is_not("running", message: "Query is already running")
    |> register_event(QueryRunScheduled)
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
