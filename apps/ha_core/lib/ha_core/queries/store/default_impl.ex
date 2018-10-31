defmodule HaCore.Queries.Store.DefaultImpl do
  @moduledoc false
  use HaCore.Queries.QueryStore

  alias HaCore.Repo
  alias HaCore.Queries.Query

  @impl true
  def count(user) do
    Repo.count(Query)
  end

  @impl true
  def list(user) do
    Repo.all(Query)
  end

  @impl true
  def get!(user, id) do
    Repo.get!(Query, id)
  end

  @impl true
  def save(changeset) do
    transaction_result =
      Repo.transaction(fn ->
        query = Repo.insert_or_update(changeset)
        for dispatch <- Map.get(changeset, :__register_event__, []), do: dispatch.(query)
        query
      end)

    with {:ok, query} <- transaction_result, do: query
  end

end
