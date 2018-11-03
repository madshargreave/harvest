defmodule HaCore.Datasets.Events.DatasetDeleted do
  @moduledoc false
  alias HaSupport.DomainEvent

  defstruct dataset_id: nil,
            user_id: nil

  def make(dataset) do
    DomainEvent.make(
      :dataset_deleted,
      %__MODULE__{
        user_id: dataset.deleted_by.id,
        dataset_id: dataset.id
      }
    )
  end

end
