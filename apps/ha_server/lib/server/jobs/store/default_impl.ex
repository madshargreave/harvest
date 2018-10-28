defmodule HAServer.Jobs.Store.DefaultImpl do
  @moduledoc false
  use HAServer.Jobs.Store

  alias HAServer.Repo
  alias HAServer.Jobs.Job

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
    transaction_result =
      Repo.transaction(fn ->
        job = Repo.insert_or_update(changeset)
        for dispatch <- Map.get(changeset, :__register_event__, []), do: dispatch.(job)
        job
      end)

    with {:ok, job} <- transaction_result, do: job
  end

end
