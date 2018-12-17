defmodule HaCore.Jobs.Events.JobCreated do
  @moduledoc false
  alias HaSupport.DomainEvent

  def make(context, job) do
    DomainEvent.make(
      context,
      :job_created,
      ExCore.DTO.JobDTO.from(job)
    )
  end

end
