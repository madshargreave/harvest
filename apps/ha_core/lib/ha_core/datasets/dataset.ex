defmodule HaCore.Datasets.Dataset do
  @moduledoc """
  Query model
  """
  use HaCore.Schema

  alias HaCore.Datasets.Dataset
  alias HaCore.Datasets.Events.{DatasetCreated, DatasetDeleted}

  schema "datasets" do
    field :user_id, :string
    field :name, :string
    field :deleted_at, :naive_datetime
    field :deleted_by, :map, virtual: true
    timestamps()
  end

  @doc """
  Creates a new query
  """
  @spec create_changeset(HaCore.user, map) :: Changeset.t
  def create_changeset(user, attrs \\ %{}) do
    required = ~w(user_id name)a
    optional = ~w()a

    %__MODULE__{}
    |> cast(attrs, optional ++ required)
    |> put_change(:user_id, user.id)
    |> validate_required(required)
    |> register_event(DatasetCreated)
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
    |> register_event(DatasetDeleted)
  end

end
