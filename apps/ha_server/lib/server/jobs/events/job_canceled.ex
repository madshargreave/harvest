defmodule HAServer.Jobs.Events.JobCanceled do
  @moduledoc false
  defstruct job_id: nil,
            user_id: nil

  def make(job) do
    %{
      type: :job_caneled,
      data: %__MODULE__{
        user_id: job.canceled_by.id,
        job_id: job.id
      }
    }
  end

end
