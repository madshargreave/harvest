defmodule HaCore.Queries.Query do
  @moduledoc """
  Query model
  """
  use HaCore.Schema

  alias HaCore.Queries.QueryEvents.{
    QuerySavedEvent,
    QueryDeletedEvent
  }
  alias HaCore.Queries.QueryCommands.{
    SaveQueryCommand,
    DeleteQueryCommand
  }

  swagger_schema "queries" do
    field :user_id, :binary_id
    field :name, :string
    field :query, :string
    field :saved, :boolean
    field :status, :string
    field :deleted_at, :naive_datetime
    # field :deleted_by, :binary_id
    timestamps()
  end

  @spec save_changeset(HaCore.user, SaveQueryCommand.t) :: Changeset.t
  def save_changeset(user, %SaveQueryCommand{
    name: name,
    query: query
  }) do
    required = ~w(user_id name query)a
    optional = ~w()a

    %__MODULE__{}
    |> cast(%{
      user_id: user.id,
      name: name,
      query: query
    }, optional ++ required)
    |> put_change(:saved, true)
    |> put_change(:status, "created")
    |> validate_required(required)
    |> register_event(QuerySavedEvent)
  end

  @spec delete_changeset(t, HaCore.user) :: Changeset.t
  def delete_changeset(struct, user) do
    required = ~w()a
    optional = ~w()a

    struct
    |> change()
    |> put_change_now(:deleted_at)
    |> put_change(:deleted_by, user.id)
    |> register_event(QueryDeletedEvent)
  end

end
