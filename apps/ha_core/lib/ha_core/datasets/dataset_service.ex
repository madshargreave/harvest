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

  @store Application.get_env(:ha_core, :dataset_store_impl) || DefaultImpl

  @doc """
  Creates a new dataset
  """
  @spec create(HaCore.user, map) :: {:ok, Dataset.t} | {:error, InvalidChangesetError.t}
  def create(user, attrs \\ %{}) do
    changeset = Dataset.create_changeset(user, attrs)
    @store.save(changeset)
  end

  @doc """
  Deletes an existing dataset
  """
  @spec delete(HaCore.user, Datasets.id) :: {:ok, Dataset.t} | {:error, InvalidChangesetError.t}
  def delete(user, dataset_id) do
    dataset = @store.get!(user, dataset_id)
    changeset = Dataset.delete_changeset(user, dataset)
    @store.save(changeset)
  end

end
