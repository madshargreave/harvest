defmodule HaCore.Streams.Stream do
  @moduledoc """
  Query model
  """
  use HaCore.Schema

  alias HaCore.Streams.Stream
  alias HaCore.Streams.Events

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
    |> register_event(Events.StreamRegistered)
  end

  @spec pause_changeset(t) :: Changeset.t
  def pause_changeset(stream) do
    stream
    |> change
    |> put_change(:status, "paused")
    |> register_event(Events.StreamPaused)
  end

  @spec resume_changeset(t) :: Changeset.t
  def resume_changeset(stream) do
    stream
    |> change
    |> put_change(:status, "active")
    |> register_event(Events.StreamResumed)
  end

  @spec delete_changeset(t) :: Changeset.t
  def delete_changeset(stream) do
    now = NaiveDateTime.utc_now
    stream
    |> change
    |> put_change(:status, "deleted")
    |> put_change(:deleted_at, now)
    |> register_event(Events.StreamDeleted)
  end

end
