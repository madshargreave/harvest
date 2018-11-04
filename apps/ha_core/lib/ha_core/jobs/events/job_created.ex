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

  def make(context, job) do
    DomainEvent.make(
      context,
      :job_created,
      %__MODULE__{
        id: job.id,
        destination_id: job.configuration.destination_id,
        status: job.status,
        primary_key: job.configuration.destination.primary_key,
        steps: job.steps,
        inserted_at: job.inserted_at
      }
    )
  end

end
