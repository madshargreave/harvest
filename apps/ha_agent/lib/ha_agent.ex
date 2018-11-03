defmodule HaAgent do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      {Redix, [[], [name: :redix_agent]]},
      worker(HaAgent.Queries.QueryHandler, [])
    ]

    opts = [strategy: :one_for_one, name: HaAgent.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
