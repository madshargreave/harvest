defmodule HaAgent.Handlers.QueryHandler do
  @moduledoc """
  Runs and schedules queries
  """
  use HaSupport.Consumer,
    topics: [
      "live_query_created",
      "live_query_resumed",
      "live_query_paused",
      "live_query_deleted"
    ],
    adapter: {
      HaSupport.Consumer.RedisAdapter,
      [
        redix: :agent_redix,
        consumer: fn -> Node.self() end,
        group: "agent-domain-consumer"
      ]
    }

  alias HaCore.LiveQueries.Events.{
    LiveQueryRegistered,
    LiveQueryResumed,
    LiveQueryPaused,
    LiveQueryDeleted
  }

  alias HaCore.Queries.Events.{
    QueryCreated
  }

  alias HaCore.Jobs.Events.{
    JobCanceled
  }

  alias HaAgent.{
    Request,
    Runner,
    Scheduler
  }

  @impl true
  def handle_event(%{data: %LiveQueryRegistered{}} = event) do
    request = %Request{scope: event.actor_id, id: event.data.name, query: event.data.query}
    {:ok, _} = Scheduler.start(request)
    :ok
  end

  @impl true
  def handle_event(%{data: %LiveQueryResumed{}} = event) do
    request = %Request{id: event.data.id, query: event.data.query}
    Scheduler.start(request)
  end

  @impl true
  def handle_event(%{data: %LiveQueryPaused{}} = event),
    do: Scheduler.stop(event.data.id)
  def handle_event(%{data: %LiveQueryDeleted{}} = event),
    do: Scheduler.stop(event.data.id)

  @impl true
  def handle_event(%{data: %QueryCreated{}} = event) do
    request = %Request{id: event.data.id, query: event.data.query}
    Runner.run(request)
  end

  @impl true
  def handle_event(%{data: %JobCanceled{}} = event) do
    Runner.cancel(event.data.id)
  end

end
