defmodule HaAgent do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      # cluster_supervisor(),
      # horde_registry(),
      # horde_supervisor(),
      scheduler_supervisor(),
      consumer_supervisor(),
      %{
        id: {Redix, 1},
        start: {Redix, :start_link, [[], [name: :agent_redix]]}
      },
      %{
        id: {Redix, 2},
        start: {Redix, :start_link, [[], [name: :agent_dispatcher_redix]]}
      },
      # {HaAgent.Handlers.QueryHandler, []}
    ]

    opts = [strategy: :one_for_one, name: HaAgent.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp cluster_supervisor do
    {Cluster.Supervisor, [topologies, [name: HaAgent.NodeClusterSupervisor]]}
  end

  defp topologies do
    [
      example: [
        strategy: Cluster.Strategy.Epmd,
        config: [hosts: [:"agent1@localhost", :"agent2@localhost"]]
      ]
    ]
  end

  defp horde_registry do
    {Horde.Registry, [name: HaAgent.ClusterRegistry]}
  end

  defp horde_supervisor do
    opts = [
      name: HaAgent.ClusterSupervisor,
      strategy: :one_for_one
    ]
    {Horde.Supervisor, opts}
  end

  defp scheduler_supervisor do
    {HaAgent.Scheduler.Supervisor, []}
  end

  defp consumer_supervisor do
    {HaAgent.Consumer.Supervisor, []}
  end

end
