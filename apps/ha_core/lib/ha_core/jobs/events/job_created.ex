defmodule HaCore.Jobs.Events.JobCreated do
  @moduledoc false
  alias HaSupport.DomainEvent

  defstruct id: nil,
            destination_id: nil,
            name: nil,
            status: nil,
            primary_key: nil,
            steps: nil,
            inserted_at: nil

  def make(job) do
    DomainEvent.make(
      :job_created,
      %__MODULE__{
        id: job.id,
        destination_id: job.destination_id,
        status: job.status,
        primary_key: job.destination.primary_key,
        steps: job.steps,
        inserted_at: job.inserted_at
      }
    )
  end

end
