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
    Repo.save(changeset)
  end

end
