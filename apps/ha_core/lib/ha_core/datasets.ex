defmodule HaCore.Datasets do
  @moduledoc """
  The datasets context.
  """
  alias HaCore.Accounts

  alias HaCore.Datasets.Store.DefaultImpl, as: DefaultDatasetStore
  alias HaCore.Datasets.{
    Dataset,
    DatasetService
  }

  @store_impl Application.get_env(:ha_core, :dataset_store_impl) || DefaultDatasetStore

  @type dataset :: Dataset.t
  @type id :: binary

  defdelegate count_datasets(user), to: @store_impl, as: :count
  defdelegate list_datasets(user), to: @store_impl, as: :list
  defdelegate get_dataset!(user, id), to: @store_impl, as: :get!
  defdelegate create_dataset(user, attrs), to: DatasetService, as: :create
  defdelegate delete_dataset(user, dataset), to: DatasetService, as: :delete

end

