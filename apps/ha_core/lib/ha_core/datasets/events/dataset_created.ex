defmodule HaCore.Datasets.Events.DatasetCreated do
  @moduledoc false
  defstruct data: nil

  def make(dataset) do
    %{
      type: :dataset_created,
      data: dataset
    }
  end

end
