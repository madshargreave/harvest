defmodule HaCore.Tables.Table do
  @moduledoc """
  Query model
  """
  use HaCore.Schema

  alias HaCore.Tables.Table
  alias HaCore.Tables.Events.{TableCreated, TableDeleted}

  schema "tables" do
    field :name, :string
    field :size, :integer, default: 0
    field :primary_key, :string
    timestamps()
  end

  @doc """
  Creates a new query
  """
  @spec create_changeset(map) :: Changeset.t
  def create_changeset(attrs \\ %{}) do
    required = ~w(name primary_key)a
    optional = ~w(size)a

    %__MODULE__{}
    |> cast(attrs, optional ++ required)
    |> validate_required(required)
    |> register_event(TableCreated)
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
    |> register_event(TableDeleted)
  end

end
