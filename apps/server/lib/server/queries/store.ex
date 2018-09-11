defmodule Harvest.Server.Queries.Store do
  @moduledoc """
  Account store
  """
  import Ecto.Query, warn: false

  alias Harvest.Server.Repo
  alias Harvest.Server.Queries.Query

  @doc """
  Returns number of queries.
  """
  def count do
    Repo.count(Query)
  end

  @doc """
  Returns the list of queries.
  """
  def list do
    Repo.all(Query)
  end

  @doc """
  Gets a single query.

  Raises `Ecto.NoResultsError` if the query does not exist.
  """
  def get!(id) do
    Repo.get!(Query, id)
  end

  @doc """
  Creates a query.
  """
  def create(attrs \\ %{}) do
    %Query{}
    |> Query.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a query.
  """
  def update(%Query{} = query, attrs) do
    query
    |> Query.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a query.
  """
  def delete(%Query{} = query) do
    Repo.delete(Query)
  end

end
