defmodule HaCore.Tables.Table do
  @moduledoc """
  Query model
  """
  use HaCore.Schema

  alias HaCore.Tables.Events
  alias HaCore.Tables.Commands

  swagger_schema "tables" do
    field :name, :string
    field :favorited, :boolean, default: false
    field :saved, :boolean, default: false
    field :size, :integer, default: 0
    field :deleted_at, :naive_datetime
    timestamps()
  end

  @doc """
  Saved the table and optionally sets a new name
  """
  @spec save_changeset(t, Commands.SaveTableCommand.t) :: Changeset.t
  def save_changeset(table, command) do
    table
    |> change
    |> put_change_if_present(:name, command.name)
    |> put_change(:saved, true)
    |> register_event(Events.TableSaved)
  end

  @doc """
  Marks table as deleted
  """
  @spec delete_changeset(t, Commands.DeleteTableCommand.t) :: Changeset.t
  def delete_changeset(table, command) do
    table
    |> change
    |> put_change_now(:deleted_at)
    |> register_event(Events.TableDeleted)
  end

end
