defmodule HaCore.Jobs.Store.DefaultImpl do
  @moduledoc false
  use HaCore.Jobs.JobStore

  alias HaCore.Repo
  alias HaCore.Jobs.Job

  @impl true
  def count(user) do
    Repo.count(Job)
  end

  @impl true
  def list(user) do
    Repo.all(Job)
  end

  @impl true
  def get!(user, id) do
    Repo.get!(Job, id)
  end

  @impl true
  def save(changeset) do
    Repo.save(changeset)
  end

end
