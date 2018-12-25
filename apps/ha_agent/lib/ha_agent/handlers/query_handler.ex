defmodule HaAgent.Handlers.QueryHandler do
  @moduledoc """
  Runs and schedules queries
  """
  use GenConsumer, otp_app: :ha_agent

  alias ExdStreams.Api.Commands.SelectCommand
  alias HaSupport.DomainEvent
  alias HaCore.Jobs.Job

  @impl true
  def handle_event(%DomainEvent{
    type: :job_created,
    data: job
  } = event) do
    context = %{id: event.actor_id}
    {:ok, query} = HaDSL.parse(job.configuration.query)
    command =
      %SelectCommand{
        table: job.destination_id,
        query: query,
        meta: %{
          job_id: job.id,
          event: event
        }
      }
    ExdStreams.connect(context)
    ExdStreams.run(context, command)
    ExdStreams.close(context)
    :ok
  end

  @impl true
  def handle_event(_) do
    :ok
  end

end
