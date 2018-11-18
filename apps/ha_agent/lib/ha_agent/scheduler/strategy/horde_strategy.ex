defmodule HaAgent.Scheduler.HordeScheduler do
  @moduledoc """
  Delegates query execution to Exd library
  """
  use HaAgent.Scheduler.Adapter

  alias HaSupport.DomainEvent
  alias HaSupport.Serdes.Adapter.JSONSerdes
  alias HaAgent.ClusterSupervisor
  alias HaAgent.Stream.Consumer

  @impl true
  def start(request) do
    {:ok, query} = HaDSL.parse(request.id, request.query)

    query =
      %Exd.Query{
        query |
          into: fn i ->
            IO.inspect "[queries:#{request.id}]: #{i.value}"
            HaAgent.Dispatcher.dispatch(
              [i.value],
              name: :agent_dispatcher_redix,
              serdes: JSONSerdes,
              topic: "queries:#{request.id}"
            )
          end
      }

    child_spec = %{
      id: request.id,
      start: {Exd.Repo, :start_link, [query]}
    }
    Horde.Supervisor.start_child(ClusterSupervisor, child_spec)
  end

  @impl true
  def stop(request) do
    Horde.Supervisor.stop(ClusterSupervisor, request.id)
  end

end
