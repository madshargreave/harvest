defmodule HaCore.Datasets.DatasetService do
  @moduledoc """
  Datasets service
  """
  import Ecto

  alias HaCore.Datasets
  alias HaCore.Datasets.Store.DefaultImpl
  alias HaCore.Datasets.{
    Dataset,
    DatasetStore
  }

  @store Application.get_env(:ha_server, :dataset_store_impl) || DefaultImpl

  @doc """
  Creates a new job and enqueues it processing
  """
  @spec save(HaCore.user, map) :: {:ok, Dataset.t} | {:error, InvalidChangesetError.t}
  def save(user, attrs \\ %{}) do
    changeset = Dataset.save_changeset(user, attrs)
    @store.save(changeset)
  end

  @doc """
  Cancels a running job
  """
  @spec delete(HaCore.user, Datasets.id) :: {:ok, Dataset.t} | {:error, InvalidChangesetError.t}
  def delete(user, job_id) do
    job = @store.get!(user, job_id)
    changeset = Dataset.delete_changeset(user, job)
    @store.save(changeset)
  end

end
