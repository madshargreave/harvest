defmodule HaCore.Jobs.Events.JobCreated do
  @moduledoc false
  alias HaSupport.DomainEvent

  defstruct id: nil,
            name: nil,
            configuration: nil,
            inserted_at: nil

  def make(context, query) do
    DomainEvent.make(
      context,
      :job_created,
      %__MODULE__{
        id: query.id,
        configuration: query.configuration,
        inserted_at: query.inserted_at
      }
    )
  end

end
