defmodule HaCore.Jobs.Events.JobCompleted do
  @moduledoc false
  alias HaSupport.DomainEvent

  defstruct id: nil,
            timestamp: nil

  def make(context, job) do
    DomainEvent.make(
      context,
      :job_completed,
      %__MODULE__{
        id: job.id,
        timestamp: job.updated_at
      }
    )
  end

end
