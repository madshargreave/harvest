defmodule HaCore.LiveQueries.LiveQuery do
  @moduledoc """
  Query model
  """
  use HaCore.Schema

  alias HaCore.LiveQueries.LiveQuery
  alias HaCore.LiveQueries.Events

  schema "queries" do
    field :user_id, :binary_id
    field :status, :string
    field :name, :string
    field :query, :string
    field :params, :map, default: %{}
    field :saved, :boolean
    field :live, :boolean
    field :deleted_at, :naive_datetime
    field :deleted_by, :map, virtual: true
    timestamps()
  end

  @spec register_changeset(HaCore.user, map) :: Changeset.t
  def register_changeset(user, attrs \\ %{}) do
    required = ~w(user_id query)a
    optional = ~w(name params)a

    %__MODULE__{}
    |> cast(attrs, optional ++ required)
    |> put_change(:status, "active")
    |> put_change(:user_id, user.id)
    |> validate_required(required)
    |> register_event(Events.LiveQueryRegistered)
  end

  @spec pause_changeset(t) :: Changeset.t
  def pause_changeset(live_query) do
    live_query
    |> change
    |> put_change(:status, "paused")
    |> register_event(Events.LiveQueryPaused)
  end

  @spec resume_changeset(t) :: Changeset.t
  def resume_changeset(live_query) do
    live_query
    |> change
    |> put_change(:status, "active")
    |> register_event(Events.LiveQueryResumed)
  end

  @spec delete_changeset(t) :: Changeset.t
  def delete_changeset(live_query) do
    now = NaiveDateTime.utc_now
    live_query
    |> change
    |> put_change(:status, "deleted")
    |> put_change(:deleted_at, now)
    |> register_event(Events.LiveQueryDeleted)
  end

end
