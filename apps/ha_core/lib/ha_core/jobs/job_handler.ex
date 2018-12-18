defmodule HaCore.Jobs.JobHandler do
  @moduledoc false
  use GenConsumer, otp_app: :ha_core

  alias HaCore.Jobs.JobService
  alias HaCore.Commands.CompleteJobCommand

  @impl true
  def handle_event(%{
    type: :query_done,
    start_at: started_at,
    end_at: ended_at,
    meta: %{
      job_id: job_id,
      actor_id: actor_id,
      correlation_id: correlation_id
    }
  } = event) do
    event = %HaSupport.DomainEvent{actor_id: actor_id, correlation_id: correlation_id, data: event}
    command = %CompleteJobCommand{
      id: job_id,
      started_at: started_at,
      ended_at: ended_at
    }
    JobService.complete(event, command)
    :ok
  end

  def handle_event(event) do
    IO.inspect "Received job #{inspect event.type}:#{event.correlation_id}"
    :ok
  end

end
