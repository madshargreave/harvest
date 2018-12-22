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
  } = event) do
    LogService.capture(event, [
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
    LogService.capture(event, [
      %Log{
        job_id: job_id,
        type: "completed",
        data: %{
          started_at: started_at,
          ended_at: ended_at
        },
        timestamp: ended_at
      }
    ])
  end

  # @impl true
  # def handle_event(%{
  #   type: :job_activity,
  #   timestamp: timestamp,
  #   meta: %{
  #     url: url
  #   }
  # }) do
  #   LogService.capture(nil, [
  #     %Log{
  #       type: "activity",
  #       data: %{
  #         plugin: "fetch",
  #         url: url
  #       },
  #       timestamp: timestamp
  #     }
  #   ])
  # end

  def handle_event(event) do
    # IO.inspect event
    :ok
  end

end
