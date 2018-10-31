defmodule HaCore.Datasets.Events.DatasetCreated do
  @moduledoc false
  defstruct data: nil

  def make(dataset) do
    %{
      type: :dataset_created,
      data: %{
        id: dataset.id,
        name: dataset.name,
        user_id: dataset.user_id,
        inserted_at: dataset.inserted_at
      }
    }
  end

end
