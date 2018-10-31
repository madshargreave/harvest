defmodule HaCore.Queries.Service do
  @moduledoc """
  Jobs service
  """
  import Ecto

  alias HaCore.Queries
  alias HaCore.Queries.Store.DefaultImpl
  alias HaCore.Queries.{Query, Store}

  @store Application.get_env(:ha_server, :job_store_impl) || DefaultImpl

  @doc """
  Creates a new job and enqueues it processing
  """
  @spec save(HaCore.user, map) :: {:ok, Query.t} | {:error, InvalidChangesetError.t}
  def save(user, attrs \\ %{}) do
    changeset = Query.save_changeset(user, attrs)
    @store.save(changeset)
  end

  @doc """
  Cancels a running job
  """
  @spec delete(HaCore.user, Jobs.job_id) :: {:ok, Query.t} | {:error, InvalidChangesetError.t}
  def delete(user, job_id) do
    job = @store.get!(user, job_id)
    changeset = Query.delete_changeset(user, job)
    @store.save(changeset)
  end

end
