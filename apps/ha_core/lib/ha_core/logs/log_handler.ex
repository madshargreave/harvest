defmodule HaCore.Logs.LogHandler do
  @moduledoc false
  require Logger
  use GenConsumer, otp_app: :ha_core

  alias HaSupport.DomainEvent
  alias HaCore.Logs.{Log, LogService}

  @impl true
  def handle_event(%DomainEvent{
    type: :job_created,
    data: job
  }) do
    LogService.capture([
      %Log{
        job_id: job.id,
        type: "created",
        data: %{
          table_id: job.destination.id
        },
        timestamp: job.inserted_at
      }
    ])
  end

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
    LogService.capture([
      %Log{
        job_id: job_id,
        type: "complete",
        data: %{
          started_at: started_at,
          ended_at: ended_at
        },
        timestamp: ended_at
      }
    ])
  end

  def handle_event(_event) do
    :ok
  end

end
