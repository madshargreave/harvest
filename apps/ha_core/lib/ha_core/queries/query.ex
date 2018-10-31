defmodule HaCore.Queries.Query do
  @moduledoc """
  Query model
  """
  use HaCore.Schema

  alias HaCore.Queries.Query
  alias HaCore.Queries.Events.{QuerySaved, QueryDeleted}

  schema "queries" do
    field :user_id, :string
    field :query, :map
    field :schedule, :string
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

end
