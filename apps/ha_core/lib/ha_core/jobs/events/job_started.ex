defmodule HaCore.Jobs.Events.JobStarted do
  @moduledoc false
  alias HaSupport.DomainEvent

  def make(context, job) do
    DomainEvent.make(context, :job_started, job)
  end

end
