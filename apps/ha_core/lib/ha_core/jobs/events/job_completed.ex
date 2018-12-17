defmodule HaCore.Jobs.Events.JobCompleted do
  @moduledoc false
  alias HaSupport.DomainEvent

  def make(context, job) do
    DomainEvent.make(
      context,
      :job_completed,
      ExCore.DTO.JobDTO.from(job)
    )
  end

end
