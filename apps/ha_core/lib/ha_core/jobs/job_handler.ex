defmodule HaCore.Jobs.JobHandler do
  @moduledoc false
  require Logger
  use GenConsumer, otp_app: :ha_core

  alias HaCore.Jobs.JobService
  alias HaCore.Jobs.Commands.{StartJobCommand, CompleteJobCommand}

  @impl true
  def handle_event(%{
    type: :query_started,
    started_at: started_at,
    meta: %{
      job_id: job_id
    }
  } = event) do
    JobService.start(
      nil,
      %StartJobCommand{
        id: job_id,
        started_at: started_at
      }
    )
  end

  @impl true
  def handle_event(%{
    type: :query_done,
    start_at: started_at,
    end_at: ended_at,
    meta: %{
      job_id: job_id
    }
  } = event) do
    JobService.complete(
      nil,
      %CompleteJobCommand{
        id: job_id,
        started_at: started_at,
        ended_at: ended_at
      }
    )
  end

  def handle_event(event) do
    :ok
  end

end
