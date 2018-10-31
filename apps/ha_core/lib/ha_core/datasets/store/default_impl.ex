defmodule HaCore.Datasets.Store.DefaultImpl do
  @moduledoc false
  use HaCore.Datasets.DatasetStore

  alias HaCore.Repo
  alias HaCore.Datasets.Dataset

  @impl true
  def count(user) do
    Repo.count(Dataset)
  end

  @impl true
  def list(user) do
    Repo.all(Dataset)
  end

  @impl true
  def get!(user, id) do
    Repo.get!(Dataset, id)
  end

  @impl true
  def save(changeset) do
    Repo.save(changeset)
  end

end
