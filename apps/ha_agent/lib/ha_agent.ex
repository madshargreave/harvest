defmodule HaAgent do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      # scheduler_supervisor(),
      # consumer_supervisor(),
      # %{
      #   id: {Redix, 1},
      #   start: {Redix, :start_link, [[], [name: :agent_redix]]}
      # },
      # %{
      #   id: {Redix, 2},
      #   start: {Redix, :start_link, [[], [name: :agent_dispatcher_redix]]}
      # },
      {HaAgent.Handlers.QueryHandler, []}
    ]

    opts = [strategy: :one_for_one, name: HaAgent.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp scheduler_supervisor do
    {HaAgent.Scheduler.Supervisor, []}
  end

  defp consumer_supervisor do
    {HaAgent.Consumer.Supervisor, []}
  end

end
