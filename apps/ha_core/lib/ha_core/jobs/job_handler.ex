defmodule HaCore.Jobs.JobHandler do
  @moduledoc false
  require Logger
  use GenConsumer, otp_app: :ha_core

  alias HaSupport.DomainEvent
  alias HaCore.Jobs.JobService
  alias HaCore.Commands.CompleteJobCommand

  @impl true
  def handle_event(%{
    type: :query_done,
    start_at: started_at,
    end_at: ended_at,
    meta: %{
      job_id: job_id,
      event: event
    }
  }) do
    JobService.complete(
      event,
      %CompleteJobCommand{
        id: job_id,
        started_at: started_at,
        ended_at: ended_at
      }
    )
  end

  def handle_event(event) do
    IO.inspect "Received job #{inspect event.type}:#{event.correlation_id}"
    :ok
  end

end
