defmodule HaCore.Jobs.Events.JobCompleted do
  @moduledoc false
  alias HaSupport.DomainEvent

  def make(context, job) do
    DomainEvent.make(context, :job_completed, job)
  end

end
