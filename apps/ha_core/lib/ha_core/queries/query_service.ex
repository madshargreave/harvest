defmodule HaCore.Queries.QueryService do
  @moduledoc """
  Queries service
  """
  alias HaCore.Queries.{
    Query,
    QueryStore,
    QueryCommands
  }

  @doc """
  Saves a query
  """
  @spec save(HaCore.context, QueryCommands.SaveQueryCommand.t) :: {:ok, Query.t} | {:error, InvalidChangesetError.t}
  def save(user, command) do
    changeset = Query.save_changeset(user, command)
    QueryStore.save(user, changeset)
  end

  @doc """
  Deletes a saved query
  """
  @spec delete(HaCore.context, QueryCommands.DeleteQueryCommand.t) :: {:ok, Query.t} | {:error, InvalidChangesetError.t}
  def delete(user, command) do
    query = QueryStore.get!(user, command.query_id)
    changeset = Query.delete_changeset(query, user) |> IO.inspect
    QueryStore.save(user, changeset) |> IO.inspect
  end

end
