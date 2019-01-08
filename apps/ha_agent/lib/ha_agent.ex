defmodule HaAgent do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      # {HaAgent.Handlers.QueryHandler, []}
    ]

    opts = [strategy: :one_for_one, name: HaAgent.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
