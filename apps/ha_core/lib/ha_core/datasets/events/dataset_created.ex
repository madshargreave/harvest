defmodule HaCore.Datasets.Events.DatasetCreated do
  @moduledoc false
  defstruct job: nil

  def make(job) do
    %{
      type: :job_created,
      data: job
    }
  end

end
