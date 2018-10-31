defmodule HaCore.Datasets.Events.DatasetDeleted do
  @moduledoc false
  defstruct dataset_id: nil,
            user_id: nil

  def make(dataset) do
    %{
      type: :dataset_deleted,
      data: %__MODULE__{
        user_id: dataset.deleted_by.id,
        dataset_id: dataset.id
      }
    }
  end

end
