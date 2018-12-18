defmodule HaCore.Jobs.Events.JobCreated do
  @moduledoc false
  alias HaSupport.DomainEvent

  def make(context, job) do
    DomainEvent.make(context, :job_created, job)
  end

end
