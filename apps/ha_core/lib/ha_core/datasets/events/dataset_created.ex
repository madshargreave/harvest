defmodule HaCore.Datasets.Events.DatasetCreated do
  @moduledoc false
  alias HaCore.DomainEvent

  defstruct id: nil,
            name: nil,
            user_id: nil,
            inserted_at: nil

  def make(dataset) do
    DomainEvent.make(
      :dataset_created,
      %__MODULE__{
        id: dataset.id,
        name: dataset.name,
        user_id: dataset.user_id,
        inserted_at: dataset.inserted_at
      }
    )
  end

end
